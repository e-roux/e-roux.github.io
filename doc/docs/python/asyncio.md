## Objects

Awaitable objects - [`Coroutines`](#coroutines), [ `Tasks` ](#tasks-and-futures), and [ `Futures` ](#tasks-and-futures) - can be used in an await expression.

### Coroutines

> Computer program components that generalize subroutines for
> non-preemptive multitasking, by allowing execution to be suspended and
> resumed (*Wikipedia*)


??? abstract "Coroutines vs threads"

    Coroutines are very similar to threads. However, coroutines are
    cooperatively multitasked, whereas threads are typically preemptively
    multitasked. This means that coroutines provide concurrency but not
    parallelism. [...] There is no need for synchronisation primitives such as
    mutexes, semaphores, etc. in order to guard critical sections, and there is
    no need for support from the operating system.

    Source: Wikipedia

Python [`Coroutines`](https://docs.python.org/3/library/asyncio-task.html#coroutines) run in an [event loop](https://docs.python.org/3/library/asyncio-task.html#coroutines). Coroutines are a backbone of asyncio and third party async frameworks like [Curio](https://github.com/dabeaz/curio) or [trio](https://github.com/python-trio/trio)

### Tasks (and Futures)

 `Futures` represent a placeholder for an action that return a result (or not).
 `Tasks` are a subclass of
 [`Futures`](https://docs.python.org/3/library/asyncio-future.html).

`Tasks` wraps `Coroutines` and are used to schedule coroutines concurrently.
They are created with `asyncio.create_task()` or by wrapping a `Future` object
with `asyncio.ensure_future()`

!!! danger

     Future doesn't necessarily wrap a coroutine.
     
     e.g.: [`loop.create_future()`](https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.create_future)
     creates a Future, [`future.set_result(result)`](https://docs.python.org/3/library/asyncio-future.html#asyncio.Future.set_result) sets its results. Such
     a future can be awaited by a coroutine, or even run using
     [`loop.run_until_complete(future)`](https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.run_until_complete), but there is no coroutine behind it. 

     Source: [http://disq.us/p/1r7l8th](http://disq.us/p/1r7l8th)

Event loops use cooperative scheduling: an event loop runs one Task at a time. If a coroutine awaits on a Future, the Task suspends the execution of the
coroutine and waits for the completion of the Future, the event loop runs
meanwhile other Tasks, callbacks, or performs IO operations. When the Future is
done, the execution of the wrapped coroutine resumes.

Both are not thread-safe.

## Execution

### Event loop


```python

```
