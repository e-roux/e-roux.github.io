Apache Airflow
==============

Authoring and Scheduling
------------------------

Dataset
^^^^^^^

Logical grouping of data, defined by unentrypted URI:

.. code:: python

    from airflow.datasets import Dataset

    example_dataset = Dataset("s3://dataset-bucket/example.csv")

    # can also be defined with extra dict
    example_dataset = Dataset("s3://dataset/example.csv", extra={"team": "trainees"})

Usage in DAG
""""""""""""

.. tab-set::

    .. tab-item:: Simple dataset

        .. code:: python

            example_dataset = Dataset("s3://dataset/example.csv")

            # simple dataset
            with DAG(dag_id="producer", ...):
                BashOperator(task_id="producer", outlets=[example_dataset], ...)

            with DAG(dag_id="consumer", schedule=[example_dataset], ...):
                ...

        Downstream DAGs are ran after pre-requesite update.

    .. tab-item:: Multiple dataset

        .. code:: python

            example_dataset_1 = Dataset("s3://dataset/example_1.csv")
            example_dataset_2 = Dataset("s3://dataset/example_2.csv")
            example_dataset_3 = Dataset("s3://dataset/example_3.csv")

            with DAG(
                dag_id="multiple_datasets_example",
                schedule=[
                    example_dataset_1,
                    example_dataset_2,
                    example_dataset_3,
                ],
                ...,
            ):
                ...

        Downstream DAGs are ran after full pre-requesites update.

        .. image:: img/multiple_dataset.svg


.. attention:: Timetable and Dataset can not be mixed in the ``schedule`` parameter.

``triggering_dataset_events`` template
""""""""""""""""""""""""""""""""""""""

``triggering_dataset_events`` can be used in templating, its type is a ``dict[str, list[DatasetEvent]]``, e.g.:


.. dropdown:: Example
    :margin: 0
    :class-body: p-0

    .. code:: python

        example_dataset = Dataset("snowflake://my_db.my_schema.my_table")

        with DAG(dag_id="load_data", schedule="@hourly", ...): 
            # Do some stuff
            ...

        with DAG(dag_id="query_data", schedule=[example_dataset], ...):
            
            # In operators
            SQLExecuteQueryOperator(
                task_id="query",
                conn_id="snowflake_default",
                sql="""
                  SELECT *
                  FROM my_db.my_schema.my_table
                  WHERE "updated_at" >= '{{ (triggering_dataset_events.values() | first | first).source_dag_run.data_interval_start }}'
                  AND "updated_at" < '{{ (triggering_dataset_events.values() | first | first).source_dag_run.data_interval_end }}';
                """,
            )

            # In task, must be defined as parameter
            @task
            def print_triggering_dataset_events(triggering_dataset_events=None):
                for dataset, dataset_list in triggering_dataset_events.items():
                    print(dataset, dataset_list)
                    print(dataset_list[0].source_dag_run.dag_id)

        print_triggering_dataset_events()


https://airflow.apache.org/docs/apache-airflow/stable/templates-ref.html#templates-ref

Timetables
^^^^^^^^^^

Airflow has builtin support for cron expressions  and time delta :py:class:`airflow.timetables.interval.DeltaDataIntervalTimetable`.

.. tab-set::

    .. tab-item:: Base

        **class** :py:class:`airflow.timetables.base.DataInterval` 

        A data interval for a DagRun to operate over. Both ``start`` and ``end`` MUST
        be aware, i.e. contain timezone information.
        
        **class** :py:class:`airflow.timetables.base.TimeRestriction` 

        Restriction on when a DAG can be scheduled for a run.

        - ``earliest``/``latest`` are time
        - ``catchup``: if False, the run must also not be earlier than the
        current time, i.e. “missed” schedules are not backfilled.

        These values are generally set on the DAG or task’s start_date,
        end_date, and catchup arguments.

        Both earliest and latest, if not None, are inclusive; a DAG run can
        happen exactly at either point of time. They are guaranteed to be aware
        (i.e. contain timezone information) for TimeRestriction instances
        created by Airflow.

        **class** :py:class:`airflow.timetables.base.DagRunInfo` 

        **class** :py:class:`airflow.timetables.base.Timetable` 


    .. tab-item:: Simple

        **class** :py:class:`airflow.timetables.simple.NullTimetable` 

        **class** :py:class:`airflow.timetables.simple.OnceTimetable` 
        
        **class** :py:class:`airflow.timetables.simple.ContinuousTimetable` 


    .. tab-item:: Trigger

        **class** :py:class:`airflow.timetables.trigger.CronTriggerTimetable` 

        accepts a cron expression, and triggers DAG runs according to it.

        .. code:: python

            from airflow.timetables.trigger import CronTriggerTimetable

            # At 01:00 on Wednesday
            @dag(schedule=CronTriggerTimetable("0 1 * * 3", timezone="UTC"), ...)  
            def example_dag():
                pass

    .. tab-item:: DeltaDataInterval
    
        ... 
        
    .. tab-item:: Interval
    
        :py:class:`airflow.timetables.interval.CronDataIntervalTimetable`

        :py:class:`airflow.timetables.interval.DeltaDataIntervalTimetable`

    .. tab-item:: Events

        :py:class:`airflow.timetables.events.EventsTimetable`
        
            ...

