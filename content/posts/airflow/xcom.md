---
title: "Xcom"
author: Emmanuel Roux
type: "posts"
date: 2022-01-31T09:21:27+01:00
subtitle: ""
image: ""
tags: []
draft: true
resources:
  - name: "Airflow official documentation"
    href: "https://airflow.apache.org/docs/apache-airflow/stable/concepts/xcoms.html"
  - name: "Astronomer: Custom XCom Backends"
    href: https://www.astronomer.io/guides/custom-xcom-backends
  - name: "Airflow summit 2021: Customizing Xcom for data sharing between tasks"
    href: https://airflowsummit.org/slides/2021/h5_6-CustomizingXcom.pdf
  - name: "Marc Lambertini's ultimate guide"
    href: https://marclamberti.com/blog/airflow-xcom/
---

## `XCom` model

`XCom` backends inherit from the [`BaseXCom`](https://airflow.apache.org/docs/apache-airflow/stable/_api/airflow/models/xcom/index.html). It is a [`sqlalchemy` model](https://docs.sqlalchemy.org/en/14/orm/mapping_styles.html#orm-declarative-mapping) and maps to the `xcom` table.

{{< highlight lang="Python" options="linenos=table" attr="airflow.models.xcom" attrlink="https://github.com/apache/airflow/blob/main/airflow/models/xcom.py" >}}
class BaseXCom(Base, LoggingMixin):
    """Base class for XCom objects."""

    __tablename__ = "xcom"

    key = Column(String(512, **COLLATION_ARGS), primary_key=True)
    value = Column(LargeBinary)
    timestamp = Column(UtcDateTime, default=timezone.utcnow, nullable=False)
    execution_date = Column(UtcDateTime, primary_key=True)

    # source information
    task_id = Column(String(ID_LEN, **COLLATION_ARGS), primary_key=True)
    dag_id = Column(String(ID_LEN, **COLLATION_ARGS), primary_key=True)
{{< / highlight >}}

`XCom`are identified by `key`, attached to a pair (`dag_id`, `task_id`) for a
certain `execution_date` and owns a `value` limited to the
[`LargeBinary`](https://docs.sqlalchemy.org/en/14/core/type_basics.html#sqlalchemy.types.LargeBinary)
size. This size depends on the backend choosen but as airflow is not a
processing framework like spark, big data must be avoided.

## `XCom` production and consumption

### within the *taskflow* api

https://airflow.apache.org/docs/apache-airflow/stable/tutorial_taskflow_api.html#consuming-xcoms-between-decorated-and-traditional-tasks


## Custom `XCom` backend

Custom backends must subclass the  class and implement two methods:
- `serialize_value`
- `deserialize_value`
- `clear` (Optional)
