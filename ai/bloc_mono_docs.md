# Getting Started

?> In order to start using bloc you must have the [Dart SDK](https://dart.dev/get-dart) installed on your machine.

## Overview

Bloc consists of several pub packages:

- [bloc](https://pub.dev/packages/bloc) - Core bloc library
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - Powerful Flutter Widgets built to work with bloc in order to build fast, reactive mobile applications.
- [angular_bloc](https://pub.dev/packages/angular_bloc) - Powerful Angular Components built to work with bloc in order to build fast, reactive web applications.
- [hydrated_bloc](https://pub.dev/packages/hydrated_bloc) - An extension to the bloc state management library which automatically persists and restores bloc states.
- [replay_bloc](https://pub.dev/packages/replay_bloc) - An extension to the bloc state management library which adds support for undo and redo.

## Installation

For a [Dart](https://dart.dev/) application, we need to add the `bloc` package to our `pubspec.yaml` as a dependency.

[pubspec.yaml](_snippets/getting_started/bloc_pubspec.yaml.md ':include')

For a [Flutter](https://flutter.dev/) application, we need to add the `flutter_bloc` package to our `pubspec.yaml` as a dependency.

[pubspec.yaml](_snippets/getting_started/flutter_bloc_pubspec.yaml.md ':include')

For an [AngularDart](https://angulardart.dev/) application, we need to add the `angular_bloc` package to our `pubspec.yaml` as a dependency.

[pubspec.yaml](_snippets/getting_started/angular_bloc_pubspec.yaml.md ':include')

Next we need to install bloc.

!> Make sure to run the following command from the same directory as your `pubspec.yaml` file.

- For Dart or AngularDart run `pub get`

- For Flutter run `flutter packages get`

## Import

Now that we have successfully installed bloc, we can create our `main.dart` and import `bloc`.

[main.dart](_snippets/getting_started/bloc_main.dart.md ':include')

For a Flutter application we can import `flutter_bloc`.

[main.dart](_snippets/getting_started/flutter_bloc_main.dart.md ':include')

For an AngularDart application we can import `angular_bloc`.

[main.dart](_snippets/getting_started/angular_bloc_main.dart.md ':include')


# Core Concepts (package:bloc)

?> Please make sure to carefully read the following sections before working with [package:bloc](https://pub.dev/packages/bloc).

There are several core concepts that are critical to understanding how to use the bloc package.

In the upcoming sections, we're going to discuss each of them in detail as well as work through how they would apply to a counter app.

## Streams

?> Check out the official [Dart Documentation](https://dart.dev/tutorials/language/streams) for more information about `Streams`.

> A stream is a sequence of asynchronous data.

In order to use the bloc library, it is critical to have a basic understanding of `Streams` and how they work.

> If you're unfamiliar with `Streams` just think of a pipe with water flowing through it. The pipe is the `Stream` and the water is the asynchronous data.

We can create a `Stream` in Dart by writing an `async*` (async generator) function.

[count_stream.dart](_snippets/core_concepts/count_stream.dart.md ':include')

By marking a function as `async*` we are able to use the `yield` keyword and return a `Stream` of data. In the above example, we are returning a `Stream` of integers up to the `max` integer parameter.

Every time we `yield` in an `async*` function we are pushing that piece of data through the `Stream`.

We can consume the above `Stream` in several ways. If we wanted to write a function to return the sum of a `Stream` of integers it could look something like:

[sum_stream.dart](_snippets/core_concepts/sum_stream.dart.md ':include')

By marking the above function as `async` we are able to use the `await` keyword and return a `Future` of integers. In this example, we are awaiting each value in the stream and returning the sum of all integers in the stream.

We can put it all together like so:

[main.dart](_snippets/core_concepts/streams_main.dart.md ':include')

Now that we have a basic understanding of how `Streams` work in Dart we're ready to learn about the core component of the bloc package: a `Cubit`.

## Cubit

> A `Cubit` is a class which extends `BlocBase` and can be extended to manage any type of state.

![Cubit Architecture](assets/cubit_architecture_full.png)

A `Cubit` can expose functions which can be invoked to trigger state changes.

> States are the output of a `Cubit` and represent a part of your application's state. UI components can be notified of states and redraw portions of themselves based on the current state.

> **Note**: For more information about the origins of `Cubit` checkout [the following issue](https://github.com/felangel/cubit/issues/69).

### Creating a Cubit

We can create a `CounterCubit` like:

[counter_cubit.dart](_snippets/core_concepts/counter_cubit.dart.md ':include')

When creating a `Cubit`, we need to define the type of state which the `Cubit` will be managing. In the case of the `CounterCubit` above, the state can be represented via an `int` but in more complex cases it might be necessary to use a `class` instead of a primitive type.

The second thing we need to do when creating a `Cubit` is specify the initial state. We can do this by calling `super` with the value of the initial state. In the snippet above, we are setting the initial state to `0` internally but we can also allow the `Cubit` to be more flexible by accepting an external value:

[counter_cubit.dart](_snippets/core_concepts/counter_cubit_initial_state.dart.md ':include')

This would allow us to instantiate `CounterCubit` instances with different initial states like:

[main.dart](_snippets/core_concepts/counter_cubit_instantiation.dart.md ':include')

### State Changes

> Each `Cubit` has the ability to output a new state via `emit`.

[counter_cubit.dart](_snippets/core_concepts/counter_cubit_increment.dart.md ':include')

In the above snippet, the `CounterCubit` is exposing a public method called `increment` which can be called externally to notify the `CounterCubit` to increment its state. When `increment` is called, we can access the current state of the `Cubit` via the `state` getter and `emit` a new state by adding 1 to the current state.

!> The `emit` method is protected, meaning it should only be used inside of a `Cubit`.

### Using a Cubit

We can now take the `CounterCubit` we've implemented and put it to use!

#### Basic Usage

[main.dart](_snippets/core_concepts/counter_cubit_basic_usage.dart.md ':include')

In the above snippet, we start by creating an instance of the `CounterCubit`. We then print the current state of the cubit which is the initial state (since no new states have been emitted yet). Next, we call the `increment` function to trigger a state change. Finally, we print the state of the `Cubit` again which went from `0` to `1` and call `close` on the `Cubit` to close the internal state stream.

#### Stream Usage

`Cubit` exposes a `Stream` which allows us to receive real-time state updates:

[main.dart](_snippets/core_concepts/counter_cubit_stream_usage.dart.md ':include')

In the above snippet, we are subscribing to the `CounterCubit` and calling print on each state change. We are then invoking the `increment` function which will emit a new state. Lastly, we are calling `cancel` on the `subscription` when we no longer want to receive updates and closing the `Cubit`.

?> **Note**: `await Future.delayed(Duration.zero)` is added for this example to avoid canceling the subscription immediately.

!> Only subsequent state changes will be received when calling `listen` on a `Cubit`.

### Observing a Cubit

> When a `Cubit` emits a new state, a `Change` occurs. We can observe all changes for a given `Cubit` by overriding `onChange`.

[counter_cubit.dart](_snippets/core_concepts/counter_cubit_on_change.dart.md ':include')

We can then interact with the `Cubit` and observe all changes output to the console.

[main.dart](_snippets/core_concepts/counter_cubit_on_change_usage.dart.md ':include')

The above example would output:

[script](_snippets/core_concepts/counter_cubit_on_change_output.sh.md ':include')

?> **Note**: A `Change` occurs just before the state of the `Cubit` is updated. A `Change` consists of the `currentState` and the `nextState`.

#### BlocObserver

One added bonus of using the bloc library is that we can have access to all `Changes` in one place. Even though in this application we only have one `Cubit`, it's fairly common in larger applications to have many `Cubits` managing different parts of the application's state.

If we want to be able to do something in response to all `Changes` we can simply create our own `BlocObserver`.

[simple_bloc_observer_on_change.dart](_snippets/core_concepts/simple_bloc_observer_on_change.dart.md ':include')

?> **Note**: All we need to do is extend `BlocObserver` and override the `onChange` method.

In order to use the `SimpleBlocObserver`, we just need to tweak the `main` function:

[main.dart](_snippets/core_concepts/simple_bloc_observer_on_change_usage.dart.md ':include')

The above snippet would then output:

[script](_snippets/core_concepts/counter_cubit_on_change_usage_output.sh.md ':include')

?> **Note**: The internal `onChange` override is called first, which calls `super.onChange` notifying the `onChange` in the `BlocObserver`.

?> 💡 **Tip**: In `BlocObserver` we have access to the `Cubit` instance in addition to the `Change` itself.

### Error Handling

> Every `Cubit` has an `addError` method which can be used to indicate that an error has occurred.

[counter_cubit.dart](_snippets/core_concepts/counter_cubit_on_error.dart.md ':include')

?> **Note**: `onError` can be overridden within the `Cubit` to handle all errors for a specific `Cubit`.

`onError` can also be overridden in `BlocObserver` to handle all reported errors globally.

[simple_bloc_observer.dart](_snippets/core_concepts/simple_bloc_observer_on_error.dart.md ':include')

If we run the same program again we should see the following output:

[script](_snippets/core_concepts/counter_cubit_on_error_output.sh.md ':include')

?> **Note**: Just as with `onChange`, the internal `onError` override is invoked before the global `BlocObserver` override.

## Bloc

> A `Bloc` is a more advanced class which relies on `events` to trigger `state` changes rather than functions. `Bloc` also extends `BlocBase` which means it has a similar public API as `Cubit`. However, rather than calling a `function` on a `Bloc` and directly emitting a new `state`, `Blocs` receive `events` and convert the incoming `events` into outgoing `states`.

![Bloc Architecture](assets/bloc_architecture_full.png)

### Creating a Bloc

Creating a `Bloc` is similar to creating a `Cubit` except in addition to defining the state that we'll be managing, we must also define the event that the `Bloc` will be able to process.

> Events are the input to a Bloc. They are commonly added in response to user interactions such as button presses or lifecycle events like page loads.

[counter_bloc.dart](_snippets/core_concepts/counter_bloc.dart.md ':include')

Just like when creating the `CounterCubit`, we must specify an initial state by passing it to the superclass via `super`.

### State Changes

`Bloc` requires us to register event handlers via the `on<Event>` API, as opposed to functions in `Cubit`. An event handler is responsible for converting any incoming events into zero or more outgoing states.

[counter_bloc.dart](_snippets/core_concepts/counter_bloc_event_handler.dart.md ':include')

?> 💡 **Tip**: an `EventHandler` has access to the added event as well as an `Emitter` which can be used to emit zero or more states in response to the incoming event.

We can then update the `EventHandler` to handle the `CounterIncrementPressed` event:

[counter_bloc.dart](_snippets/core_concepts/counter_bloc_increment.dart.md ':include')

In the above snippet, we have registered an `EventHandler` to manage all `CounterIncrementPressed` events. For each incoming `CounterIncrementPressed` event we can access the current state of the bloc via the `state` getter and `emit(state + 1)`.

?> **Note**: Since the `Bloc` class extends `BlocBase`, we have access to the current state of the bloc at any point in time via the `state` getter just like in `Cubit`.

!> Blocs should never directly `emit` new states. Instead every state change must be output in response to an incoming event within an `EventHandler`.

!> Both blocs and cubits will ignore duplicate states. If we emit `State nextState` where `state == nextState`, then no state change will occur.

### Using a Bloc

At this point, we can create an instance of our `CounterBloc` and put it to use!

#### Basic Usage

[main.dart](_snippets/core_concepts/counter_bloc_usage.dart.md ':include')

In the above snippet, we start by creating an instance of the `CounterBloc`. We then print the current state of the `Bloc` which is the initial state (since no new states have been emitted yet). Next, we add the `CounterIncrementPressed` event to trigger a state change. Finally, we print the state of the `Bloc` again which went from `0` to `1` and call `close` on the `Bloc` to close the internal state stream.

?> **Note**: `await Future.delayed(Duration.zero)` is added to ensure we wait for the next event-loop iteration (allowing the `EventHandler` to process the event).

#### Stream Usage

Just like with `Cubit`, a `Bloc` is a special type of `Stream`, which means we can also subscribe to a `Bloc` for real-time updates to its state:

[main.dart](_snippets/core_concepts/counter_bloc_stream_usage.dart.md ':include')

In the above snippet, we are subscribing to the `CounterBloc` and calling print on each state change. We are then adding the `CounterIncrementPressed` event which triggers the `on<CounterIncrementPressed>` `EventHandler` and emits a new state. Lastly, we are calling `cancel` on the subscription when we no longer want to receive updates and closing the `Bloc`.

?> **Note**: `await Future.delayed(Duration.zero)` is added for this example to avoid canceling the subscription immediately.

### Observing a Bloc

Since `Bloc` extends `BlocBase`, we can observe all state changes for a `Bloc` using `onChange`.

[counter_bloc.dart](_snippets/core_concepts/counter_bloc_on_change.dart.md ':include')

We can then update `main.dart` to:

[main.dart](_snippets/core_concepts/counter_bloc_on_change_usage.dart.md ':include')

Now if we run the above snippet, the output will be:

[script](_snippets/core_concepts/counter_bloc_on_change_output.sh.md ':include')

One key differentiating factor between `Bloc` and `Cubit` is that because `Bloc` is event-driven, we are also able to capture information about what triggered the state change.

We can do this by overriding `onTransition`.

> The change from one state to another is called a `Transition`. A `Transition` consists of the current state, the event, and the next state.

[counter_bloc.dart](_snippets/core_concepts/counter_bloc_on_transition.dart.md ':include')

If we then rerun the same `main.dart` snippet from before, we should see the following output:

[script](_snippets/core_concepts/counter_bloc_on_transition_output.sh.md ':include')

?> **Note**: `onTransition` is invoked before `onChange` and contains the event which triggered the change from `currentState` to `nextState`.

#### BlocObserver

Just as before, we can override `onTransition` in a custom `BlocObserver` to observe all transitions that occur from a single place.

[simple_bloc_observer.dart](_snippets/core_concepts/simple_bloc_observer_on_transition.dart.md ':include')

We can initialize the `SimpleBlocObserver` just like before:

[main.dart](_snippets/core_concepts/simple_bloc_observer_on_transition_usage.dart.md ':include')

Now if we run the above snippet, the output should look like:

[script](_snippets/core_concepts/simple_bloc_observer_on_transition_output.sh.md ':include')

?> **Note**: `onTransition` is invoked first (local before global) followed by `onChange`.

Another unique feature of `Bloc` instances is that they allow us to override `onEvent` which is called whenever a new event is added to the `Bloc`. Just like with `onChange` and `onTransition`, `onEvent` can be overridden locally as well as globally.

[counter_bloc.dart](_snippets/core_concepts/counter_bloc_on_event.dart.md ':include')

[simple_bloc_observer.dart](_snippets/core_concepts/simple_bloc_observer_on_event.dart.md ':include')

We can run the same `main.dart` as before and should see the following output:

[script](_snippets/core_concepts/simple_bloc_observer_on_event_output.sh.md ':include')

?> **Note**: `onEvent` is called as soon as the event is added. The local `onEvent` is invoked before the global `onEvent` in `BlocObserver`.

### Error Handling

Just like with `Cubit`, each `Bloc` has an `addError` and `onError` method. We can indicate that an error has occurred by calling `addError` from anywhere inside our `Bloc`. We can then react to all errors by overriding `onError` just as with `Cubit`.

[counter_bloc.dart](_snippets/core_concepts/counter_bloc_on_error.dart.md ':include')

If we rerun the same `main.dart` as before, we can see what it looks like when an error is reported:

[script](_snippets/core_concepts/counter_bloc_on_error_output.sh.md ':include')

?> **Note**: The local `onError` is invoked first followed by the global `onError` in `BlocObserver`.

?> **Note**: `onError` and `onChange` work the exact same way for both `Bloc` and `Cubit` instances.

!> Any unhandled exceptions that occur within an `EventHandler` are also reported to `onError`.

## Cubit vs. Bloc

Now that we've covered the basics of the `Cubit` and `Bloc` classes, you might be wondering when you should use `Cubit` and when you should use `Bloc`.

### Cubit Advantages

#### Simplicity

One of the biggest advantages of using `Cubit` is simplicity. When creating a `Cubit`, we only have to define the state as well as the functions which we want to expose to change the state. In comparison, when creating a `Bloc`, we have to define the states, events, and the `EventHandler` implementation. This makes `Cubit` easier to understand and there is less code involved.

Now let's take a look at the two counter implementations:

##### CounterCubit

[counter_cubit.dart](_snippets/core_concepts/counter_cubit_full.dart.md ':include')

##### CounterBloc

[counter_bloc.dart](_snippets/core_concepts/counter_bloc_full.dart.md ':include')

The `Cubit` implementation is more concise and instead of defining events separately, the functions act like events. In addition, when using a `Cubit`, we can simply call `emit` from anywhere in order to trigger a state change.

### Bloc Advantages

#### Traceability

One of the biggest advantages of using `Bloc` is knowing the sequence of state changes as well as exactly what triggered those changes. For state that is critical to the functionality of an application, it might be very beneficial to use a more event-driven approach in order to capture all events in addition to state changes.

A common use case might be managing `AuthenticationState`. For simplicity, let's say we can represent `AuthenticationState` via an `enum`:

[authentication_state.dart](_snippets/core_concepts/authentication_state.dart.md ':include')

There could be many reasons as to why the application's state could change from `authenticated` to `unauthenticated`. For example, the user might have tapped a logout button and requested to be signed out of the application. On the other hand, maybe the user's access token was revoked and they were forcefully logged out. When using `Bloc` we can clearly trace how the application state got to a certain state.

[script](_snippets/core_concepts/authentication_transition.sh.md ':include')

The above `Transition` gives us all the information we need to understand why the state changed. If we had used a `Cubit` to manage the `AuthenticationState`, our logs would look like:

[script](_snippets/core_concepts/authentication_change.sh.md ':include')

This tells us that the user was logged out but it doesn't explain why which might be critical to debugging and understanding how the state of the application is changing over time.

#### Advanced Event Transformations

Another area in which `Bloc` excels over `Cubit` is when we need to take advantage of reactive operators such as `buffer`, `debounceTime`, `throttle`, etc.

`Bloc` has an event sink that allows us to control and transform the incoming flow of events.

For example, if we were building a real-time search, we would probably want to debounce the requests to the backend in order to avoid getting rate-limited as well as to cut down on cost/load on the backend.

With `Bloc` we can provide a custom `EventTransformer` to change the way incoming events are processed by the `Bloc`.

[counter_bloc.dart](_snippets/core_concepts/debounce_event_transformer.dart.md ':include')

With the above code, we can easily debounce the incoming events with very little additional code.

?> 💡 **Tip**: Check out [package:bloc_concurrency](https://pub.dev/packages/bloc_concurrency) for an opinionated set of event transformers.

?> 💡 **Tip**: If you are still unsure about which to use, start with `Cubit` and you can later refactor or scale-up to a `Bloc` as needed.


# Frequently Asked Questions

## State Not Updating

❔ **Question**: I'm emitting a state in my bloc but the UI is not updating. What
am I doing wrong?

💡 **Answer**: If you're using Equatable make sure to pass all properties to the
props getter.

✅ **GOOD**

[my_state.dart](_snippets/faqs/state_not_updating_good_1.dart.md ':include')

❌ **BAD**

[my_state.dart](_snippets/faqs/state_not_updating_bad_1.dart.md ':include')

[my_state.dart](_snippets/faqs/state_not_updating_bad_2.dart.md ':include')

In addition, make sure you are emitting a new instance of the state in your
bloc.

✅ **GOOD**

[my_bloc.dart](_snippets/faqs/state_not_updating_good_2.dart.md ':include')

[my_bloc.dart](_snippets/faqs/state_not_updating_good_3.dart.md ':include')

❌ **BAD**

[my_bloc.dart](_snippets/faqs/state_not_updating_bad_3.dart.md ':include')

!> `Equatable` properties should always be copied rather than modified. If an
`Equatable` class contains a `List` or `Map` as properties, be sure to use
`List.from` or `Map.from` respectively to ensure that equality is evaluated
based on the values of the properties rather than the reference.

## When to use Equatable

❔**Question**: When should I use Equatable?

💡**Answer**:

[my_bloc.dart](_snippets/faqs/equatable_yield.dart.md ':include')

In the above scenario if `StateA` extends `Equatable` only one state change will
occur (the second emit will be ignored). In general, you should use `Equatable`
if you want to optimize your code to reduce the number of rebuilds. You should
not use `Equatable` if you want the same state back-to-back to trigger multiple
transitions.

In addition, using `Equatable` makes it much easier to test blocs since we can
expect specific instances of bloc states rather than using `Matchers` or
`Predicates`.

[my_bloc_test.dart](_snippets/faqs/equatable_bloc_test.dart.md ':include')

Without `Equatable` the above test would fail and would need to be rewritten
like:

[my_bloc_test.dart](_snippets/faqs/without_equatable_bloc_test.dart.md ':include')

## Handling Errors

❔ **Question**: How can I handle an error while still showing previous data?

💡 **Answer**:

This highly depends on how the state of the bloc has been modeled. In cases
where data should still be retained even in the presence of an error, consider
using a single state class.

```dart
enum Status { initial, loading, success, failure }

class MyState {
  const MyState({
    this.data = Data.empty,
    this.error = '',
    this.status = Status.initial,
  });

  final Data data;
  final String error;
  final Status status;

  MyState copyWith({Data data, String error, Status status}) {
    return MyState(
      data: data ?? this.data,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}
```

This will allow widgets to have access to the `data` and `error` properties
simultaneously and the bloc can use `state.copyWith` to retain old data even
when an error has occurred.

```dart
on<DataRequested>((event, emit) {
  try {
    final data = await _repository.getData();
    emit(state.copyWith(status: Status.success, data: data));
  } on Exception {
    emit(state.copyWith(status: Status.failure, error: 'Something went wrong!'));
  }
});
```

## Bloc vs. Redux

❔ **Question**: What's the difference between Bloc and Redux?

💡 **Answer**:

BLoC is a design pattern that is defined by the following rules:

1. Input and Output of the BLoC are simple Streams and Sinks.
2. Dependencies must be injectable and Platform agnostic.
3. No platform branching is allowed.
4. Implementation can be whatever you want as long as you follow the above
   rules.

The UI guidelines are:

1. Each "complex enough" component has a corresponding BLoC.
2. Components should send inputs "as is".
3. Components should show outputs as close as possible to "as is".
4. All branching should be based on simple BLoC boolean outputs.

The Bloc Library implements the BLoC Design Pattern and aims to abstract RxDart
in order to simplify the developer experience.

The three principles of Redux are:

1. Single source of truth
2. State is read-only
3. Changes are made with pure functions

The bloc library violates the first principle; with bloc state is distributed
across multiple blocs. Furthermore, there is no concept of middleware in bloc
and bloc is designed to make async state changes very easy, allowing you to emit
multiple states for a single event.

## Bloc vs. Provider

❔ **Question**: What's the difference between Bloc and Provider?

💡 **Answer**: `provider` is designed for dependency injection (it wraps
`InheritedWidget`). You still need to figure out how to manage your state (via
`ChangeNotifier`, `Bloc`, `Mobx`, etc...). The Bloc Library uses `provider`
internally to make it easy to provide and access blocs throughout the widget
tree.

## Navigation with Bloc

❔ **Question**: How do I do navigation with Bloc?

💡 **Answer**: Check out [Flutter Navigation](recipesflutternavigation.md)

## BlocProvider.of() Fails to Find Bloc

❔ **Question**: When using `BlocProvider.of(context)` it cannot find the bloc.
How can I fix this?

💡 **Answer**: You cannot access a bloc from the same context in which it was
provided so you must ensure `BlocProvider.of()` is called within a child
`BuildContext`.

✅ **GOOD**

[my_page.dart](_snippets/faqs/bloc_provider_good_1.dart.md ':include')

[my_page.dart](_snippets/faqs/bloc_provider_good_2.dart.md ':include')

❌ **BAD**

[my_page.dart](_snippets/faqs/bloc_provider_bad_1.dart.md ':include')

## Project Structure

❔ **Question**: How should I structure my project?

💡 **Answer**: While there is really no right/wrong answer to this question, some
recommended references are

- [Flutter Architecture Samples - Brian Egan](https://github.com/brianegan/flutter_architecture_samples/tree/master/bloc_library)
- [Flutter Shopping Card Example](https://github.com/felangel/bloc/tree/master/examples/flutter_shopping_cart)
- [Flutter TDD Course - ResoCoder](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)

The most important thing is having a **consistent** and **intentional** project
structure.

## Adding Events within a Bloc

❔ **Question**: Is it okay to add events within a bloc?

💡 **Answer**: In most cases, events should be added externally but in some
select cases it may make sense for events to be added internally.

The most common situation in which internal events are used is when state
changes must occur in response to real-time updates from a repository. In these
situations, the repository is the stimulus for the state change instead of an
external event such as a button tap.

In the following example, the state of `MyBloc` is dependent on the current user
which is exposed via the `Stream<User>` from the `UserRepository`. `MyBloc`
listens for changes in the current user and adds an internal `_UserChanged`
event whenever a user is emitted from the user stream.

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc({required UserRepository userRepository}) : super(...) {
    on<_UserChanged>(_onUserChanged);
    _userSubscription = userRepository.user.listen(
      (user) => add(_UserChanged(user)),
    );
  }
```

By adding an internal event, we are also able to specify a custom `transformer`
for the event to determine how multiple `_UserChanged` events will be processed
-- by default they will be processed concurrently.

It's highly recommended that internal events are private. This is an explicit
way of signaling that a specific event is used only within the bloc itself and
prevents external components from knowing about the event.

```dart
sealed class MyEvent {}

// `EventA` is an external event.
final class EventA extends MyEvent {}

// `EventB` is an internal event.
// We are explicitly making `EventB` private so that it can only be used
// within the bloc.
final class _EventB extends MyEvent {}
```

We can alternatively define an external `Started` event and use the
`emit.forEach` API to handle reacting to real-time user updates:

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc({required UserRepository userRepository})
    : _userRepository = userRepository, super(...) {
    on<Started>(_onStarted);
  }

  Future<void> _onStarted(Started event, Emitter<MyState> emit) {
    return emit.forEach(
      _userRepository.user,
      onData: (user) => MyState(...)
    );
  }
}
```

The benefits of the above approach are:

- We do not need an internal `_UserChanged` event
- We do not need to manage the `StreamSubscription` manually
- We have full control over when the bloc subscribes to the stream of user
  updates

The drawbacks of the above approach are:

- We cannot easily `pause` or `resume` the subscription
- We need to expose a public `Started` event which must be added externally
- We cannot use a custom `transformer` to adjust how we react to user updates

## Exposing Public Methods

❔ **Question**: Is it okay to expose public methods on my bloc and cubit
instances?

💡 **Answer**

When creating a cubit, it's recommended to only expose public methods for the
purposes of triggering state changes. As a result, generally all public methods
on a cubit instance should return `void` or `Future<void>`.

When creating a bloc, it's recommended to avoid exposing any custom public
methods and instead notify the bloc of events by calling `add`.

# Migration Guide

?> 💡 **Tip**: Please refer to the [release log](https://github.com/felangel/bloc/releases) for more information regarding what changed in each release.

## v9.0.0

### package:hydrated_bloc

#### ✨ Reintroduce `HydratedBloc.storage` API

!> In hydrated_bloc v9.0.0, `HydratedBlocOverrides` was removed in favor of the `HydratedBloc.storage` API.

##### Rationale

Refer to the [rationale for reintroducing the Bloc.observer and Bloc.transformer overrides](/migration?id=rationale-1).

**v8.x.x**

```dart
Future<void> main() async {
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(App()),
    storage: storage,
  );
}
```

**v9.0.0**

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(App());
}
```

## v8.1.0

### package:bloc

#### ✨ Reintroduce `Bloc.observer` and `Bloc.transformer` APIs

!> In bloc v8.1.0, `BlocOverrides` was deprecated in favor of the `Bloc.observer` and `Bloc.transformer` APIs.

##### Rationale

The `BlocOverrides` API was introduced in v8.0.0 in an attempt to support scoping bloc-specific configurations such as `BlocObserver`, `EventTransformer`, and `HydratedStorage`. In pure Dart applications, the changes worked well; however, in Flutter applications the new API caused more problems than it solved.

The `BlocOverrides` API was inspired by similar APIs in Flutter/Dart:

- [HttpOverrides](https://api.flutter.dev/flutter/dart-io/HttpOverrides-class.html)
- [IOOverrides](https://api.flutter.dev/flutter/dart-io/IOOverrides-class.html)

**Problems**

While it wasn't the primary reason for these changes, the `BlocOverrides` API introduced additional complexity for developers. In addition to increasing the amount of nesting and lines of code needed to achieve the same effect, the `BlocOverrides` API required developers to have a solid understanding of [Zones](https://api.dart.dev/stable/2.17.6/dart-async/Zone-class.html) in Dart. `Zones` are not a beginner-friendly concept and failure to understand how Zones work could lead to the introduction of bugs (such as uninitialized observers, transformers, storage instances).

For example, many developers would have something like:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(...);
}
```

The above code, while appearing harmless, can actually lead to many difficult to track bugs. Whatever zone `WidgetsFlutterBinding.ensureInitialized` is initially called from will be the zone in which gesture events are handled (e.g. `onTap`, `onPressed` callbacks) due to `GestureBinding.initInstances`. This is just one of many issues caused by using `zoneValues`.

In addition, Flutter does many things behind the scenes which involve forking/manipulating Zones (especially when running tests) which can lead to unexpected behaviors (and in many cases behaviors that are outside the developer's control -- see issues below).

Due to the use of the [runZoned](https://api.flutter.dev/flutter/dart-async/runZoned.html), the transition to the `BlocOverrides` API led to the discovery of several bugs/limitations in Flutter (specifically around Widget and Integration Tests):

- https://github.com/flutter/flutter/issues/96939
- https://github.com/flutter/flutter/issues/94123
- https://github.com/flutter/flutter/issues/93676

which affected many developers using the bloc library:

- https://github.com/felangel/bloc/issues/3394
- https://github.com/felangel/bloc/issues/3350
- https://github.com/felangel/bloc/issues/3319

**v8.0.x**

```dart
void main() {
  BlocOverrides.runZoned(
    () {
      // ...
    },
    blocObserver: CustomBlocObserver(),
    eventTransformer: customEventTransformer(),
  );
}
```

**v8.1.0**

```dart
void main() {
  Bloc.observer = CustomBlocObserver();
  Bloc.transformer = customEventTransformer();

  // ...
}
```

## v8.0.0

### package:bloc

#### ❗✨ Introduce new `BlocOverrides` API

!> In bloc v8.0.0, `Bloc.observer` and `Bloc.transformer` were removed in favor of the `BlocOverrides` API.

##### Rationale

The previous API used to override the default `BlocObserver` and `EventTransformer` relied on a global singleton for both the `BlocObserver` and `EventTransformer`.

As a result, it was not possible to:

- Have multiple `BlocObserver` or `EventTransformer` implementations scoped to different parts of the application
- Have `BlocObserver` or `EventTransformer` overrides be scoped to a package
  - If a package were to depend on `package:bloc` and registered its own `BlocObserver`, any consumer of the package would either have to overwrite the package's `BlocObserver` or report to the package's `BlocObserver`.

It was also more difficult to test because of the shared global state across tests.

Bloc v8.0.0 introduces a `BlocOverrides` class which allows developers to override `BlocObserver` and/or `EventTransformer` for a specific `Zone` rather than relying on a global mutable singleton.

**v7.x.x**

```dart
void main() {
  Bloc.observer = CustomBlocObserver();
  Bloc.transformer = customEventTransformer();

  // ...
}
```

**v8.0.0**

```dart
void main() {
  BlocOverrides.runZoned(
    () {
      // ...
    },
    blocObserver: CustomBlocObserver(),
    eventTransformer: customEventTransformer(),
  );
}
```

`Bloc` instances will use the `BlocObserver` and/or `EventTransformer` for the current `Zone` via `BlocOverrides.current`. If there are no `BlocOverrides` for the zone, they will use the existing internal defaults (no change in behavior/functionality).

This allows allow each `Zone` to function independently with its own `BlocOverrides`.

```dart
BlocOverrides.runZoned(
  () {
    // BlocObserverA and eventTransformerA
    final overrides = BlocOverrides.current;

    // Blocs in this zone report to BlocObserverA
    // and use eventTransformerA as the default transformer.
    // ...

    // Later...
    BlocOverrides.runZoned(
      () {
        // BlocObserverB and eventTransformerB
        final overrides = BlocOverrides.current;

        // Blocs in this zone report to BlocObserverB
        // and use eventTransformerB as the default transformer.
        // ...
      },
      blocObserver: BlocObserverB(),
      eventTransformer: eventTransformerB(),
    );
  },
  blocObserver: BlocObserverA(),
  eventTransformer: eventTransformerA(),
);
```

#### ❗✨ Improve Error Handling and Reporting

!> In bloc v8.0.0, `BlocUnhandledErrorException` is removed. In addition, any uncaught exceptions are always reported to `onError` and rethrown (regardless of debug or release mode). The `addError` API reports errors to `onError`, but does not treat reported errors as uncaught exceptions.

##### Rationale

The goal of these changes is:

- make internal unhandled exceptions extremely obvious while still preserving bloc functionality
- support `addError` without disrupting control flow

Previously, error handling and reporting varied depending on whether the application was running in debug or release mode. In addition, errors reported via `addError` were treated as uncaught exceptions in debug mode which led to a poor developer experience when using the `addError` API (specifically when writing unit tests).

In v8.0.0, `addError` can be safely used to report errors and `blocTest` can be used to verify that errors are reported. All errors are still reported to `onError`, however, only uncaught exceptions are rethrown (regardless of debug or release mode).

#### ❗🧹 Make `BlocObserver` abstract

!> In bloc v8.0.0, `BlocObserver` was converted into an `abstract` class which means an instance of `BlocObserver` cannot be instantiated.

##### Rationale

`BlocObserver` was intended to be an interface. Since the default API implementation are no-ops, `BlocObserver` is now an `abstract` class to clearly communicate that the class is meant to be extended and not directly instantiated.

**v7.x.x**

```dart
void main() {
  // It was possible to create an instance of the base class.
  final observer = BlocObserver();
}
```

**v8.0.0**

```dart
class MyBlocObserver extends BlocObserver {...}

void main() {
  // Cannot instantiate the base class.
  final observer = BlocObserver(); // ERROR

  // Extend `BlocObserver` instead.
  final observer = MyBlocObserver(); // OK
}
```

#### ❗✨ `add` throws `StateError` if Bloc is closed

!> In bloc v8.0.0, calling `add` on a closed bloc will result in a `StateError`.

##### Rationale

Previously, it was possible to call `add` on a closed bloc and the internal error would get swallowed, making it difficult to debug why the added event was not being processed. In order to make this scenario more visible, in v8.0.0, calling `add` on a closed bloc will throw a `StateError` which will be reported as an uncaught exception and propagated to `onError`.

#### ❗✨ `emit` throws `StateError` if Bloc is closed

!> In bloc v8.0.0, calling `emit` within a closed bloc will result in a `StateError`.

##### Rationale

Previously, it was possible to call `emit` within a closed bloc and no state change would occur but there would also be no indication of what went wrong, making it difficult to debug. In order to make this scenario more visible, in v8.0.0, calling `emit` within a closed bloc will throw a `StateError` which will be reported as an uncaught exception and propagated to `onError`.

#### ❗🧹 Remove Deprecated APIs

!> In bloc v8.0.0, all previously deprecated APIs were removed.

##### Summary

- `mapEventToState` removed in favor of `on<Event>`
- `transformEvents` removed in favor of `EventTransformer` API
- `TransitionFunction` typedef removed in favor of `EventTransformer` API
- `listen` removed in favor of `stream.listen`

### package:bloc_test

#### ✨ `MockBloc` and `MockCubit` no longer require `registerFallbackValue`

!> In bloc_test v9.0.0, developers no longer need to explicitly call `registerFallbackValue` when using `MockBloc` or `MockCubit`.

##### Summary

`registerFallbackValue` is only needed when using the `any()` matcher from `package:mocktail` for a custom type. Previously, `registerFallbackValue` was needed for every `Event` and `State` when using `MockBloc` or `MockCubit`.

**v8.x.x**

```dart
class FakeMyEvent extends Fake implements MyEvent {}
class FakeMyState extends Fake implements MyState {}
class MyMockBloc extends MockBloc<MyEvent, MyState> implements MyBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMyEvent());
    registerFallbackValue(FakeMyState());
  });

  // Tests...
}
```

**v9.0.0**

```dart
class MyMockBloc extends MockBloc<MyEvent, MyState> implements MyBloc {}

void main() {
  // Tests...
}
```

### package:hydrated_bloc

#### ❗✨ Introduce new `HydratedBlocOverrides` API

!> In hydrated_bloc v8.0.0, `HydratedBloc.storage` was removed in favor of the `HydratedBlocOverrides` API.

##### Rationale

Previously, a global singleton was used to override the `Storage` implementation.

As a result, it was not possible to have multiple `Storage` implementations scoped to different parts of the application. It was also more difficult to test because of the shared global state across tests.

`HydratedBloc` v8.0.0 introduces a `HydratedBlocOverrides` class which allows developers to override `Storage` for a specific `Zone` rather than relying on a global mutable singleton.

**v7.x.x**

```dart
void main() async {
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );

  // ...
}
```

**v8.0.0**

```dart
void main() {
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () {
      // ...
    },
    storage: storage,
  );
}
```

`HydratedBloc` instances will use the `Storage` for the current `Zone` via `HydratedBlocOverrides.current`.

This allows allow each `Zone` to function independently with its own `BlocOverrides`.

## v7.2.0

### package:bloc

#### ✨ Introduce new `on<Event>` API

!> In bloc v7.2.0, `mapEventToState` was deprecated in favor of `on<Event>`. `mapEventToState` will be removed in bloc v8.0.0.

##### Rationale

The `on<Event>` API was introduced as part of [[Proposal] Replace mapEventToState with on<Event> in Bloc](https://github.com/felangel/bloc/issues/2526). Due to [an issue in Dart](https://github.com/dart-lang/sdk/issues/44616) it's not always obvious what the value of `state` will be when dealing with nested async generators (`async*`). Even though there are ways to work around the issue, one of the core principles of the bloc library is to be predictable. The `on<Event>` API was created to make the library as safe as possible to use and to eliminate any uncertainty when it comes to state changes.

?> 💡 **Tip**: For more information, [read the full proposal](https://github.com/felangel/bloc/issues/2526).

**Summary**

`on<E>` allows you to register an event handler for all events of type `E`. By default, events will be processed concurrently when using `on<E>` as opposed to `mapEventToState` which processes events `sequentially`.

**v7.1.0**

```dart
abstract class CounterEvent {}
class Increment extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    if (event is Increment) {
      yield state + 1;
    }
  }
}
```

**v7.2.0**

```dart
abstract class CounterEvent {}
class Increment extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}
```

!> Each registered `EventHandler` functions independently so it's important to register event handlers based on the type of transformer you'd like applied.

If you want to retain the exact same behavior as in v7.1.0 you can register a single event handler for all events and apply a `sequential` transformer:

```dart
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyState()) {
    on<MyEvent>(_onEvent, transformer: sequential())
  }

  FutureOr<void> _onEvent(MyEvent event, Emitter<MyState> emit) async {
    // TODO: logic goes here...
  }
}
```

You can also override the default `EventTransformer` for all blocs in your application:

```dart
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

void main() {
  Bloc.transformer = sequential<dynamic>();
  ...
}
```

#### ✨ Introduce new `EventTransformer` API

!> In bloc v7.2.0, `transformEvents` was deprecated in favor of the `EventTransformer` API. `transformEvents` will be removed in bloc v8.0.0.

##### Rationale

The `on<Event>` API opened the door to being able to provide a custom event transformer per event handler. A new `EventTransformer` typedef was introduced which enables developers to transform the incoming event stream for each event handler rather than having to specify a single event transformer for all events.

**Summary**

An `EventTransformer` is responsible for taking the incoming stream of events along with an `EventMapper` (your event handler) and returning a new stream of events.

```dart
typedef EventTransformer<Event> = Stream<Event> Function(Stream<Event> events, EventMapper<Event> mapper)
```

The default `EventTransformer` processes all events concurrently and looks something like:

```dart
EventTransformer<E> concurrent<E>() {
  return (events, mapper) => events.flatMap(mapper);
}
```

?> 💡 **Tip**: Check out [package:bloc_concurrency](https://pub.dev/packages/bloc_concurrency) for an opinionated set of custom event transformers

**v7.1.0**

```dart
@override
Stream<Transition<MyEvent, MyState>> transformEvents(events, transitionFn) {
  return events
    .debounceTime(const Duration(milliseconds: 300))
    .flatMap(transitionFn);
}
```

**v7.2.0**

```dart
/// Define a custom `EventTransformer`
EventTransformer<MyEvent> debounce<MyEvent>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

MyBloc() : super(MyState()) {
  /// Apply the custom `EventTransformer` to the `EventHandler`
  on<MyEvent>(_onEvent, transformer: debounce(const Duration(milliseconds: 300)))
}
```

#### ⚠️ Deprecate `transformTransitions` API

!> In bloc v7.2.0, `transformTransitions` was deprecated in favor of overriding the `stream` API. `transformTransitions` will be removed in bloc v8.0.0.

##### Rationale

The `stream` getter on `Bloc` makes it easy to override the outbound stream of states therefore it's no longer valuable to maintain a separate `transformTransitions` API.

**Summary**

**v7.1.0**

```dart
@override
Stream<Transition<Event, State>> transformTransitions(
  Stream<Transition<Event, State>> transitions,
) {
  return transitions.debounceTime(const Duration(milliseconds: 42));
}
```

**v7.2.0**

```dart
@override
Stream<State> get stream => super.stream.debounceTime(const Duration(milliseconds: 42));
```

## v7.0.0

### package:bloc

#### ❗ Bloc and Cubit extend BlocBase

##### Rationale

As a developer, the relationship between blocs and cubits was a bit awkward. When cubit was first introduced it began as the base class for blocs which made sense because it had a subset of the functionality and blocs would just extend Cubit and define additional APIs. This came with a few drawbacks:

- All APIs would either have to be renamed to accept a cubit for accuracy or they would need to be kept as bloc for consistency even though hierarchically it is inaccurate ([#1708](https://github.com/felangel/bloc/issues/1708), [#1560](https://github.com/felangel/bloc/issues/1560)).

- Cubit would need to extend Stream and implement EventSink in order to have a common base which widgets like BlocBuilder, BlocListener, etc. can be implemented against ([#1429](https://github.com/felangel/bloc/issues/1429)).

Later, we experimented with inverting the relationship and making bloc the base class which partially resolved the first bullet above but introduced other issues:

- The cubit API is bloated due to the underlying bloc APIs like mapEventToState, add, etc. ([#2228](https://github.com/felangel/bloc/issues/2228))
  - Developers can technically invoke these APIs and break things
- We still have the same issue of cubit exposing the entire stream API as before ([#1429](https://github.com/felangel/bloc/issues/1429))

To address these issues we introduced a base class for both `Bloc` and `Cubit` called `BlocBase` so that upstream components can still interoperate with both bloc and cubit instances but without exposing the entire `Stream` and `EventSink` API directly.

**Summary**

**BlocObserver**

**v6.1.x**

```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {...}

  @override
  void onEvent(Bloc bloc, Object event) {...}

  @override
  void onChange(Cubit cubit, Object event) {...}

  @override
  void onTransition(Bloc bloc, Transition transition) {...}

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {...}

  @override
  void onClose(Cubit cubit) {...}
}
```

**v7.0.0**

```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {...}

  @override
  void onEvent(Bloc bloc, Object event) {...}

  @override
  void onChange(BlocBase bloc, Object? event) {...}

  @override
  void onTransition(Bloc bloc, Transition transition) {...}

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {...}

  @override
  void onClose(BlocBase bloc) {...}
}
```

**Bloc/Cubit**

**v6.1.x**

```dart
final bloc = MyBloc();
bloc.listen((state) {...});

final cubit = MyCubit();
cubit.listen((state) {...});
```

**v7.0.0**

```dart
final bloc = MyBloc();
bloc.stream.listen((state) {...});

final cubit = MyCubit();
cubit.stream.listen((state) {...});
```

### package:bloc_test

#### ❗seed returns a function to support dynamic values

##### Rationale

In order to support having a mutable seed value which can be updated dynamically in `setUp`, `seed` returns a function.

**Summary**

**v7.x.x**

```dart
blocTest(
  '...',
  seed: MyState(),
  ...
);
```

**v8.0.0**

```dart
blocTest(
  '...',
  seed: () => MyState(),
  ...
);
```

#### ❗expect returns a function to support dynamic values and includes matcher support

##### Rationale

In order to support having a mutable expectation which can be updated dynamically in `setUp`, `expect` returns a function. `expect` also supports `Matchers`.

**Summary**

**v7.x.x**

```dart
blocTest(
  '...',
  expect: [MyStateA(), MyStateB()],
  ...
);
```

**v8.0.0**

```dart
blocTest(
  '...',
  expect: () => [MyStateA(), MyStateB()],
  ...
);

// It can also be a `Matcher`
blocTest(
  '...',
  expect: () => contains(MyStateA()),
  ...
);
```

#### ❗errors returns a function to support dynamic values and includes matcher support

##### Rationale

In order to support having a mutable errors which can be updated dynamically in `setUp`, `errors` returns a function. `errors` also supports `Matchers`.

**Summary**

**v7.x.x**

```dart
blocTest(
  '...',
  errors: [MyError()],
  ...
);
```

**v8.0.0**

```dart
blocTest(
  '...',
  errors: () => [MyError()],
  ...
);

// It can also be a `Matcher`
blocTest(
  '...',
  errors: () => contains(MyError()),
  ...
);
```

#### ❗MockBloc and MockCubit

##### Rationale

To support stubbing of various core APIs, `MockBloc` and `MockCubit` are exported as part of the `bloc_test` package.
Previously, `MockBloc` had to be used for both `Bloc` and `Cubit` instances which was not intuitive.

**Summary**

**v7.x.x**

```dart
class MockMyBloc extends MockBloc<MyState> implements MyBloc {}
class MockMyCubit extends MockBloc<MyState> implements MyBloc {}
```

**v8.0.0**

```dart
class MockMyBloc extends MockBloc<MyEvent, MyState> implements MyBloc {}
class MockMyCubit extends MockCubit<MyState> implements MyCubit {}
```

#### ❗Mocktail Integration

##### Rationale

Due to various limitations of the null-safe [package:mockito](https://pub.dev/packages/mockito) described [here](https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md#problems-with-typical-mocking-and-stubbing), [package:mocktail](https://pub.dev/packages/mocktail) is used by `MockBloc` and `MockCubit`. This allows developers to continue using a familiar mocking API without the need to manually write stubs or rely on code generation.

**Summary**

**v7.x.x**

```dart
import 'package:mockito/mockito.dart';

...

when(bloc.state).thenReturn(MyState());
verify(bloc.add(any)).called(1);
```

**v8.0.0**

```dart
import 'package:mocktail/mocktail.dart';

...

when(() => bloc.state).thenReturn(MyState());
verify(() => bloc.add(any())).called(1);
```

> Please refer to [#347](https://github.com/dart-lang/mockito/issues/347) as well as the [mocktail documentation](https://github.com/felangel/mocktail/tree/main/packages/mocktail) for more information.

### package:flutter_bloc

#### ❗ rename `cubit` parameter to `bloc`

##### Rationale

As a result of the refactor in `package:bloc` to introduce `BlocBase` which `Bloc` and `Cubit` extend, the parameters of `BlocBuilder`, `BlocConsumer`, and `BlocListener` were renamed from `cubit` to `bloc` because the widgets operate on the `BlocBase` type. This also further aligns with the library name and hopefully improves readability.

**Summary**

**v6.1.x**

```dart
BlocBuilder(
  cubit: myBloc,
  ...
)

BlocListener(
  cubit: myBloc,
  ...
)

BlocConsumer(
  cubit: myBloc,
  ...
)
```

**v7.0.0**

```dart
BlocBuilder(
  bloc: myBloc,
  ...
)

BlocListener(
  bloc: myBloc,
  ...
)

BlocConsumer(
  bloc: myBloc,
  ...
)
```

### package:hydrated_bloc

#### ❗storageDirectory is required when calling HydratedStorage.build

##### Rationale

In order to make `package:hydrated_bloc` a pure Dart package, the dependency on [package:path_provider](https://pub.dev/packages/path_provider) was removed and the `storageDirectory` parameter when calling `HydratedStorage.build` is required and no longer defaults to `getTemporaryDirectory`.

**Summary**

**v6.x.x**

```dart
HydratedBloc.storage = await HydratedStorage.build();
```

**v7.0.0**

```dart
import 'package:path_provider/path_provider.dart';

...

HydratedBloc.storage = await HydratedStorage.build(
  storageDirectory: await getTemporaryDirectory(),
);
```

## v6.1.0

### package:flutter_bloc

#### ❗context.bloc and context.repository are deprecated in favor of context.read and context.watch

##### Rationale

`context.read`, `context.watch`, and `context.select` were added to align with the existing [provider](https://pub.dev/packages/provider) API which many developers are familiar and to address issues that have been raised by the community. To improve the safety of the code and maintain consistency, `context.bloc` was deprecated because it can be replaced with either `context.read` or `context.watch` dependending on if it's used directly within `build`.

**context.watch**

`context.watch` addresses the request to have a [MultiBlocBuilder](https://github.com/felangel/bloc/issues/538) because we can watch several blocs within a single `Builder` in order to render UI based on multiple states:

```dart
Builder(
  builder: (context) {
    final stateA = context.watch<BlocA>().state;
    final stateB = context.watch<BlocB>().state;
    final stateC = context.watch<BlocC>().state;

    // return a Widget which depends on the state of BlocA, BlocB, and BlocC
  }
);
```

**context.select**

`context.select` allows developers to render/update UI based on a part of a bloc state and addresses the request to have a [simpler buildWhen](https://github.com/felangel/bloc/issues/1521).

```dart
final name = context.select((UserBloc bloc) => bloc.state.user.name);
```

The above snippet allows us to access and rebuild the widget only when the current user's name changes.

**context.read**

Even though it looks like `context.read` is identical to `context.bloc` there are some subtle but significant differences. Both allow you to access a bloc with a `BuildContext` and do not result in rebuilds; however, `context.read` cannot be called directly within a `build` method. There are two main reasons to use `context.bloc` within `build`:

1. **To access the bloc's state**

```dart
@override
Widget build(BuildContext context) {
  final state = context.bloc<MyBloc>().state;
  return Text('$state');
}
```

The above usage is error prone because the `Text` widget will not be rebuilt if the state of the bloc changes. In this scenario, either a `BlocBuilder` or `context.watch` should be used.

```dart
@override
Widget build(BuildContext context) {
  final state = context.watch<MyBloc>().state;
  return Text('$state');
}
```

or

```dart
@override
Widget build(BuildContext context) {
  return BlocBuilder<MyBloc, MyState>(
    builder: (context, state) => Text('$state'),
  );
}
```

!> Using `context.watch` at the root of the `build` method will result in the entire widget being rebuilt when the bloc state changes. If the entire widget does not need to be rebuilt, either use `BlocBuilder` to wrap the parts that should rebuild, use a `Builder` with `context.watch` to scope the rebuilds, or decompose the widget into smaller widgets.

2. **To access the bloc so that an event can be added**

```dart
@override
Widget build(BuildContext context) {
  final bloc = context.bloc<MyBloc>();
  return ElevatedButton(
    onPressed: () => bloc.add(MyEvent()),
    ...
  )
}
```

The above usage is inefficient because it results in a bloc lookup on each rebuild when the bloc is only needed when the user taps the `ElevatedButton`. In this scenario, prefer to use `context.read` to access the bloc directly where it is needed (in this case, in the `onPressed` callback).

```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () => context.read<MyBloc>().add(MyEvent()),
    ...
  )
}
```

**Summary**

**v6.0.x**

```dart
@override
Widget build(BuildContext context) {
  final bloc = context.bloc<MyBloc>();
  return ElevatedButton(
    onPressed: () => bloc.add(MyEvent()),
    ...
  )
}
```

**v6.1.x**

```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () => context.read<MyBloc>().add(MyEvent()),
    ...
  )
}
```

?> If accessing a bloc to add an event, perform the bloc access using `context.read` in the callback where it is needed.

**v6.0.x**

```dart
@override
Widget build(BuildContext context) {
  final state = context.bloc<MyBloc>().state;
  return Text('$state');
}
```

**v6.1.x**

```dart
@override
Widget build(BuildContext context) {
  final state = context.watch<MyBloc>().state;
  return Text('$state');
}
```

?> Use `context.watch` when accessing the state of the bloc in order to ensure the widget is rebuilt when the state changes.

## v6.0.0

### package:bloc

#### ❗BlocObserver onError takes Cubit

##### Rationale

Due to the integration of `Cubit`, `onError` is now shared between both `Bloc` and `Cubit` instances. Since `Cubit` is the base, `BlocObserver` will accept a `Cubit` type rather than a `Bloc` type in the `onError` override.

**v5.x.x**

```dart
class MyBlocObserver extends BlocObserver {
  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }
}
```

**v6.0.0**

```dart
class MyBlocObserver extends BlocObserver {
  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
  }
}
```

#### ❗Bloc does not emit last state on subscription

##### Rationale

This change was made to align `Bloc` and `Cubit` with the built-in `Stream` behavior in `Dart`. In addition, conforming this the old behavior in the context of `Cubit` led to many unintended side-effects and overall complicated the internal implementations of other packages such as `flutter_bloc` and `bloc_test` unnecessarily (requiring `skip(1)`, etc...).

**v5.x.x**

```dart
final bloc = MyBloc();
bloc.listen(print);
```

Previously, the above snippet would output the initial state of the bloc followed by subsequent state changes.

**v6.x.x**

In v6.0.0, the above snippet does not output the initial state and only outputs subsequent state changes. The previous behavior can be achieved with the following:

```dart
final bloc = MyBloc();
print(bloc.state);
bloc.listen(print);
```

?> **Note**: This change will only affect code that relies on direct bloc subscriptions. When using `BlocBuilder`, `BlocListener`, or `BlocConsumer` there will be no noticeable change in behavior.

### package:bloc_test

#### ❗MockBloc only requires State type

##### Rationale

It is not necessary and eliminates extra code while also making `MockBloc` compatible with `Cubit`.

**v5.x.x**

```dart
class MockCounterBloc extends MockBloc<CounterEvent, int> implements CounterBloc {}
```

**v6.0.0**

```dart
class MockCounterBloc extends MockBloc<int> implements CounterBloc {}
```

#### ❗whenListen only requires State type

##### Rationale

It is not necessary and eliminates extra code while also making `whenListen` compatible with `Cubit`.

**v5.x.x**

```dart
whenListen<CounterEvent,int>(bloc, Stream.fromIterable([0, 1, 2, 3]));
```

**v6.0.0**

```dart
whenListen<int>(bloc, Stream.fromIterable([0, 1, 2, 3]));
```

#### ❗blocTest does not require Event type

##### Rationale

It is not necessary and eliminates extra code while also making `blocTest` compatible with `Cubit`.

**v5.x.x**

```dart
blocTest<CounterBloc, CounterEvent, int>(
  'emits [1] when increment is called',
  build: () async => CounterBloc(),
  act: (bloc) => bloc.add(CounterEvent.increment),
  expect: const <int>[1],
);
```

**v6.0.0**

```dart
blocTest<CounterBloc, int>(
  'emits [1] when increment is called',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(CounterEvent.increment),
  expect: const <int>[1],
);
```

#### ❗blocTest skip defaults to 0

##### Rationale

Since `bloc` and `cubit` instances will no longer emit the latest state for new subscriptions, it was no longer necessary to default `skip` to `1`.

**v5.x.x**

```dart
blocTest<CounterBloc, CounterEvent, int>(
  'emits [0] when skip is 0',
  build: () async => CounterBloc(),
  skip: 0,
  expect: const <int>[0],
);
```

**v6.0.0**

```dart
blocTest<CounterBloc, int>(
  'emits [] when skip is 0',
  build: () => CounterBloc(),
  skip: 0,
  expect: const <int>[],
);
```

The initial state of a bloc or cubit can be tested with the following:

```dart
test('initial state is correct', () {
  expect(MyBloc().state, InitialState());
});
```

#### ❗blocTest make build synchronous

##### Rationale

Previously, `build` was made `async` so that various preparation could be done to put the bloc under test in a specific state. It is no longer necessary and also resolves several issues due to the added latency between the build and the subscription internally. Instead of doing async prep to get a bloc in a desired state we can now set the bloc state by chaining `emit` with the desired state.

**v5.x.x**

```dart
blocTest<CounterBloc, CounterEvent, int>(
  'emits [2] when increment is added',
  build: () async {
    final bloc = CounterBloc();
    bloc.add(CounterEvent.increment);
    await bloc.take(2);
    return bloc;
  }
  act: (bloc) => bloc.add(CounterEvent.increment),
  expect: const <int>[2],
);
```

**v6.0.0**

```dart
blocTest<CounterBloc, int>(
  'emits [2] when increment is added',
  build: () => CounterBloc()..emit(1),
  act: (bloc) => bloc.add(CounterEvent.increment),
  expect: const <int>[2],
);
```

!> `emit` is only visible for testing and should never be used outside of tests.

### package:flutter_bloc

#### ❗BlocBuilder bloc parameter renamed to cubit

##### Rationale

In order to make `BlocBuilder` interoperate with `bloc` and `cubit` instances the `bloc` parameter was renamed to `cubit` (since `Cubit` is the base class).

**v5.x.x**

```dart
BlocBuilder(
  bloc: myBloc,
  builder: (context, state) {...}
)
```

**v6.0.0**

```dart
BlocBuilder(
  cubit: myBloc,
  builder: (context, state) {...}
)
```

#### ❗BlocListener bloc parameter renamed to cubit

##### Rationale

In order to make `BlocListener` interoperate with `bloc` and `cubit` instances the `bloc` parameter was renamed to `cubit` (since `Cubit` is the base class).

**v5.x.x**

```dart
BlocListener(
  bloc: myBloc,
  listener: (context, state) {...}
)
```

**v6.0.0**

```dart
BlocListener(
  cubit: myBloc,
  listener: (context, state) {...}
)
```

#### ❗BlocConsumer bloc parameter renamed to cubit

##### Rationale

In order to make `BlocConsumer` interoperate with `bloc` and `cubit` instances the `bloc` parameter was renamed to `cubit` (since `Cubit` is the base class).

**v5.x.x**

```dart
BlocConsumer(
  bloc: myBloc,
  listener: (context, state) {...},
  builder: (context, state) {...}
)
```

**v6.0.0**

```dart
BlocConsumer(
  cubit: myBloc,
  listener: (context, state) {...},
  builder: (context, state) {...}
)
```

---

## v5.0.0

### package:bloc

#### ❗initialState has been removed

##### Rationale

As a developer, having to override `initialState` when creating a bloc presents two main issues:

- The `initialState` of the bloc can be dynamic and can also be referenced at a later point in time (even outside of the bloc itself). In some ways, this can be viewed as leaking internal bloc information to the UI layer.
- It's verbose.

**v4.x.x**

```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  ...
}
```

**v5.0.0**

```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  ...
}
```

?> For more information check out [#1304](https://github.com/felangel/bloc/issues/1304)

#### ❗BlocDelegate renamed to BlocObserver

##### Rationale

The name `BlocDelegate` was not an accurate description of the role that the class played. `BlocDelegate` suggests that the class plays an active role whereas in reality the intended role of the `BlocDelegate` was for it to be a passive component which simply observes all blocs in an application.

!> There should ideally be no user-facing functionality or features handled within `BlocObserver`.

**v4.x.x**

```dart
class MyBlocDelegate extends BlocDelegate {
  ...
}
```

**v5.0.0**

```dart
class MyBlocObserver extends BlocObserver {
  ...
}
```

#### ❗BlocSupervisor has been removed

##### Rationale

`BlocSupervisor` was yet another component that developers had to know about and interact with for the sole purpose of specifying a custom `BlocDelegate`. With the change to `BlocObserver` we felt it improved the developer experience to set the observer directly on the bloc itself.

?> This changed also enabled us to decouple other bloc add-ons like `HydratedStorage` from the `BlocObserver`.

**v4.x.x**

```dart
BlocSupervisor.delegate = MyBlocDelegate();
```

**v5.0.0**

```dart
Bloc.observer = MyBlocObserver();
```

### package:flutter_bloc

#### ❗BlocBuilder condition renamed to buildWhen

##### Rationale

When using `BlocBuilder`, we previously could specify a `condition` to determine whether the `builder` should rebuild.

```dart
BlocBuilder<MyBloc, MyState>(
  condition: (previous, current) {
    // return true/false to determine whether to call builder
  },
  builder: (context, state) {...}
)
```

The name `condition` is not very self-explanatory or obvious and more importantly, when interacting with a `BlocConsumer` the API became inconsistent because developers can provide two conditions (one for `builder` and one for `listener`). As a result, the `BlocConsumer` API exposed a `buildWhen` and `listenWhen`

```dart
BlocConsumer<MyBloc, MyState>(
  listenWhen: (previous, current) {
    // return true/false to determine whether to call listener
  },
  listener: (context, state) {...},
  buildWhen: (previous, current) {
    // return true/false to determine whether to call builder
  },
  builder: (context, state) {...},
)
```

In order to align the API and provide a more consistent developer experience, `condition` was renamed to `buildWhen`.

**v4.x.x**

```dart
BlocBuilder<MyBloc, MyState>(
  condition: (previous, current) {
    // return true/false to determine whether to call builder
  },
  builder: (context, state) {...}
)
```

**v5.0.0**

```dart
BlocBuilder<MyBloc, MyState>(
  buildWhen: (previous, current) {
    // return true/false to determine whether to call builder
  },
  builder: (context, state) {...}
)
```

#### ❗BlocListener condition renamed to listenWhen

##### Rationale

For the same reasons as described above, the `BlocListener` condition was also renamed.

**v4.x.x**

```dart
BlocListener<MyBloc, MyState>(
  condition: (previous, current) {
    // return true/false to determine whether to call listener
  },
  listener: (context, state) {...}
)
```

**v5.0.0**

```dart
BlocListener<MyBloc, MyState>(
  listenWhen: (previous, current) {
    // return true/false to determine whether to call listener
  },
  listener: (context, state) {...}
)
```

### package:hydrated_bloc

#### ❗HydratedStorage and HydratedBlocStorage renamed

##### Rationale

In order to improve code reuse between [hydrated_bloc](https://pub.dev/packages/hydrated_bloc) and [hydrated_cubit](https://pub.dev/packages/hydrated_cubit), the concrete default storage implementation was renamed from `HydratedBlocStorage` to `HydratedStorage`. In addition, the `HydratedStorage` interface was renamed from `HydratedStorage` to `Storage`.

**v4.0.0**

```dart
class MyHydratedStorage implements HydratedStorage {
  ...
}
```

**v5.0.0**

```dart
class MyHydratedStorage implements Storage {
  ...
}
```

#### ❗HydratedStorage decoupled from BlocDelegate

##### Rationale

As mentioned earlier, `BlocDelegate` was renamed to `BlocObserver` and was set directly as part of the `bloc` via:

```dart
Bloc.observer = MyBlocObserver();
```

The following change was made to:

- Stay consistent with the new bloc observer API
- Keep the storage scoped to just `HydratedBloc`
- Decouple the `BlocObserver` from `Storage`

**v4.0.0**

```dart
BlocSupervisor.delegate = await HydratedBlocDelegate.build();
```

**v5.0.0**

```dart
HydratedBloc.storage = await HydratedStorage.build();
```

#### ❗Simplified Initialization

##### Rationale

Previously, developers had to manually call `super.initialState ?? DefaultInitialState()` in order to setup their `HydratedBloc` instances. This is clunky and verbose and also incompatible with the breaking changes to `initialState` in `bloc`. As a result, in v5.0.0 `HydratedBloc` initialization is identical to normal `Bloc` initialization.

**v4.0.0**

```dart
class CounterBloc extends HydratedBloc<CounterEvent, int> {
  @override
  int get initialState => super.initialState ?? 0;
}
```

**v5.0.0**

```dart
class CounterBloc extends HydratedBloc<CounterEvent, int> {
  CounterBloc() : super(0);

  ...
}
```

# Flutter Todos Tutorial

![advanced](https://img.shields.io/badge/level-advanced-red.svg)

> In the following tutorial, we're going to build a todos app in Flutter using the Bloc library.

![demo](./assets/gifs/flutter_todos.gif)

## Key Topics

- [Bloc and Cubit](/coreconcepts?id=cubit-vs-bloc) to manage the various feature states.
- [Layered Architecture](/architecture) for separation of concerns and to facilitate reusability.
- [BlocObserver](/coreconcepts?id=blocobserver) to observe state changes.
- [BlocProvider](/flutterbloccoreconcepts?id=blocprovider), a Flutter widget which provides a bloc to its children.
- [BlocBuilder](/flutterbloccoreconcepts?id=blocbuilder), a Flutter widget that handles building the widget in response to new states.
- [BlocListener](/flutterbloccoreconcepts?id=bloclistener), a Flutter widget that handles performing side effects in response to state changes.
- [RepositoryProvider](/flutterbloccoreconcepts?id=repositoryprovider), a Flutter widget to provide a repository to its children.
- [Equatable](/faqs?id=when-to-use-equatable) to prevent unnecessary rebuilds.
- [MultiBlocListener](/flutterbloccoreconcepts?id=multibloclistener), a Flutter widget that reduces nesting when using multiple BlocListeners.

## Setup

We'll start off by creating a brand new Flutter project using the [very_good_cli](https://pub.dev/packages/very_good_cli).

```sh
very_good create flutter_app flutter_todos --desc "An example todos app that showcases bloc state management patterns."
```

?> **💡 Tip**: You can install `very_good_cli` via `dart pub global activate very_good_cli`.

Next we'll create the `todos_api`, `local_storage_todos_api`, and `todos_repository` packages using `very_good_cli`:

```sh
# create package:todos_api under packages/todos_api
very_good create dart_package todos_api --desc "The interface and models for an API providing access to todos." -o packages

# create package:local_storage_todos_api under packages/local_storage_todos_api
very_good create flutter_package local_storage_todos_api --desc "A Flutter implementation of the TodosApi that uses local storage." -o packages

# create package:todos_repository under packages/todos_repository
very_good create dart_package todos_repository --desc "A repository that handles todo related requests." -o packages
```

We can then replace the contents of `pubspec.yaml` with:

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/pubspec.yaml ':include')

Finally, we can install all the dependencies:

```sh
very_good packages get --recursive
```

## Project Structure

Our application project structure should look like:

```sh
├── lib
├── packages
│   ├── local_storage_todos_api
│   ├── todos_api
│   └── todos_repository
└── test
```

We split the project into multiple packages in order to maintain explicit dependencies for each package with clear boundaries that enforce the [single responsibility principle](https://en.wikipedia.org/wiki/Single-responsibility_principle).
Modularizing our project like this has many benefits including but not limited to:
- easy to reuse packages across multiple projects
- CI/CD improvements in terms of efficiency (run checks on only the code that has changed)
- easy to maintain the packages in isolation with their dedicated test suites, semantic versioning, and release cycle/cadence

## Architecture

![Todos Architecture Diagram](_snippets/flutter_todos_tutorial/images/todos_architecture_light.png)

> Layering our code is incredibly important and helps us iterate quickly and with confidence. Each layer has a single responsibility and can be used and tested in isolation. This allows us to keep changes contained to a specific layer in order to minimize the impact on the entire application. In addition, layering our application allows us to easily reuse libraries across multiple projects (especially with respect to the data layer).

Our application consists of three main layers:

- data layer
- domain layer
- feature layer
  - presentation/UI (widgets)
  - business logic (blocs/cubits)

**Data Layer**

This layer is the lowest layer and is responsible for retrieving raw data from external sources such as a databases, APIs, and more. Packages in the data layer generally should not depend on any UI and can be reused and even published on [pub.dev](https://pub.dev) as a standalone package. In this example, our data layer consists of the `todos_api` and `local_storage_todos_api` packages.

**Domain Layer**

This layer combines one or more data providers and applies "business rules" to the data. Each component in this layer is called a repository and each repository generally manages a single domain. Packages in the repository layer should generally only interact with the data layer. In this example, our repository layer consists of the `todos_repository` package.

**Feature Layer**

This layer contains all of the application-specific features and use cases. Each feature generally consists of some UI and business logic. Features should generally be independent of other features so that they can easily be added/removed without impacting the rest of the codebase. Within each feature, the state of the feature along with any business logic is managed by blocs. Blocs interact with zero or more repositories. Blocs react to events and emit states which trigger changes in the UI. Widgets within each feature should generally only depend on the corresponding bloc and render UI based on the current state. The UI can notify the bloc of user input via events. In this example, our application will consist of the `home`, `todos_overview`, `stats`, and `edit_todos` features.

Now that we've gone over the layers at a high level, let's start building our application starting with the data layer!

## Data Layer

The data layer is the lowest layer in our application and consists of raw data providers. Packages in this layer are primarily concerned with where/how data is coming from. In this case our data layer will consist of the `TodosApi`, which is an interface, and the `LocalStorageTodosApi`, which is an implementation of the `TodosApi` backed by `shared_preferences`.

### TodosApi

The `todos_api` package will export a generic interface for interacting/managing todos. Later we'll implement the `TodosApi` using `shared_preferences`. Having an abstraction will make it easy to support other implementations without having to change any other part of our application. For example, we can later add a `FirestoreTodosApi`, which uses `cloud_firestore` instead of `shared_preferences`, with minimal code changes to the rest of the application. 

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/todos_api/pubspec.yaml ':include')

[todos_api.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/todos_api/lib/src/todos_api.dart ':include')

#### Todo model

Next we'll define our `Todo` model.

The first thing of note is that the `Todo` model doesn't live in our app — it's part of the `todos_api` package. This is because the `TodosApi` defines APIs that return/accept `Todo` objects. The model is a Dart representation of the raw Todo object that will be stored/retrieved.

The `Todo` model uses [json_serializable](https://pub.dev/packages/json_serializable) to handle the json (de)serialization. If you are following along, you will have to run the [code generation step](https://pub.dev/packages/json_serializable#running-the-code-generator) to resolve the compiler errors.

[todo.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/todos_api/lib/src/models/todo.dart ':include')

`json_map.dart` provides a `typedef` for code checking and linting.

[json_map.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/todos_api/lib/src/models/json_map.dart ':include')

The model of the `Todo` is defined in `todos_api/models/todo.dart` and is exported by `package:todos_api/todos_api.dart`.

#### Streams vs Futures

In a previous version of this tutorial, the `TodosApi` was `Future`-based rather than `Stream`-based.

For an example of a `Future`-based API see [Brian Egan's implementation in his Architecture Samples](https://github.com/brianegan/flutter_architecture_samples/tree/master/todos_repository_core).

A `Future`-based implementation could consist of two methods: `loadTodos` and `saveTodos` (note the plural). This means, a full list of todos must be provided to the method each time.

- One limitation of this approach is that the standard CRUD (Create, Read, Update, and Delete) operation requires sending the full list of todos with each call. For example, on an Add Todo screen, one cannot just send the added todo item. Instead, we must keep track of the entire list and provide the entire new list of todos when persisting the updated list.
- A second limitation is that `loadTodos` is a one-time delivery of data. The app must contain logic to ask for updates periodically. 

In the current implementation, the `TodosApi` exposes a `Stream<List<Todo>>` via `getTodos()` which will report real-time updates to all subscribers when the list of todos has changed.

In addition, todos can be created, deleted, or updated individually. For example, both deleting and saving a todo are done with only the `todo` as the argument. It's not necessary to provide the newly updated list of todos each time.

### LocalStorageTodosApi

This package implements the `todos_api` using the [`shared_preferences`](https://pub.dev/packages/shared_preferences) package.

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/local_storage_todos_api/pubspec.yaml ':include')

[local_storage_todos_api.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/local_storage_todos_api/lib/src/local_storage_todos_api.dart ':include')

## Repository Layer

A [repository](/architecture?id=repository) is part of the business layer. A repository depends on one or more data providers that have no business value, and combines their public API into APIs that provide business value. In addition, having a repository layer helps abstract data acquisition from the rest of the application, allowing us to change where/how data is being stored without affecting other parts of the app.

### TodosRepository


[todos_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/todos_repository/lib/src/todos_repository.dart ':include')

Instantiating the repository requires specifying a `TodosApi`, which we discussed earlier in this tutorial, so we added it as a dependency in our `pubspec.yaml`:

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/todos_repository/pubspec.yaml ':include')

#### Library Exports

In addition to exporting the `TodosRepository` class, we also export the `Todo` model from the `todos_api` package. This step prevents tight coupling between the application and the data providers.

[todos_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/packages/todos_repository/lib/todos_repository.dart ':include')

We decided to re-export the same `Todo` model from the `todos_api`, rather than redefining a separate model in the `todos_repository`, because in this case we are in complete control of the data model. In many cases, the data provider will not be something that you can control. In those cases, it becomes increasingly important to maintain your own model definitions in the repository layer to maintain full control of the interface and API contract.

## Feature Layer

### Entrypoint

Our app's entrypoint is `main.dart`. In this case, there are three versions:

#### `main_development.dart`

[main_development.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/main_development.dart ':include')

#### `main_staging.dart`

[main_staging.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/main_staging.dart ':include')

#### `main_production.dart`

[main_production.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/main_production.dart ':include')

The most notable thing is the concrete implementation of the `local_storage_todos_api` is instantiated within each entrypoint.

### Bootstrapping

`bootstrap.dart` loads our `BlocObserver` and creates the instance of `TodosRepository`.

[bootstrap.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/bootstrap.dart ':include')

### App

`App` wraps a `RepositoryProvider` widget that provides the repository to all children. Since both the `EditTodoPage` and `HomePage` subtrees are descendents, all the blocs and cubits can access the repository.

`AppView` creates the `MaterialApp` and configures the theme and localizations.

[app.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/app/app.dart ':include')

### Theme

This provides theme definition for light and dark mode.

[theme.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/theme/theme.dart ':include')

### Home

The home feature is responsible for managing the state of the currently-selected tab and displays the correct subtree.

#### HomeState

There are only two states associated with the two screens: `todos` and `stats`.

?> **Note**: `EditTodo` is a separate route therefore it isn't part of the `HomeState`.

[home_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/home/cubit/home_state.dart ':include')

#### HomeCubit

A cubit is appropriate in this case due to the simplicity of the business logic. We have one method `setTab` to change the tab.

[home_cubit.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/home/cubit/home_cubit.dart ':include')

#### HomeView

`view.dart` is a barrel file that exports all relevant UI components for the home feature.

[view.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/home/view/view.dart ':include')

`home_page.dart` contains the UI for the root page that the user will see when the app is launched.

[home_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/home/view/home_page.dart ':include')

A simplified representation of the widget tree for the `HomePage` is:

```
├── HomePage
│   └── BlocProvider<HomeCubit>
│       └── HomeView
│           ├── context.select<HomeCubit, HomeTab>
│           └── BottomAppBar
│               └── HomeTabButton(s)
│                   └── context.read<HomeCubit>
```

The `HomePage` provides an instance of `HomeCubit` to `HomeView`. `HomeView` uses `context.select` to selectively rebuild whenever the tab changes.
This allows us to easily widget test `HomeView` by providing a mock `HomeCubit` and stubbing the state.

The `BottomAppBar` contains `HomeTabButton` widgets which call `setTab` on the `HomeCubit`. The instance of the cubit is looked up via `context.read` and the appropriate method is invoked on the cubit instance.

!> `context.read` doesn't listen for changes, it is just used to access to `HomeCubit` and call `setTab`.

### TodosOverview

The todos overview feature allows users to manage their todos by creating, editing, deleting, and filtering todos.

#### TodosOverviewEvent

Let's create `todos_overview/bloc/todos_overview_event.dart` and define the events.

[todos_overview_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/bloc/todos_overview_event.dart ':include')

- `TodosOverviewSubscriptionRequested`: This is the startup event. In response, the bloc subscribes to the stream of todos from the `TodosRepository`.
- `TodosOverviewTodoDeleted`: This deletes a Todo.
- `TodosOverviewTodoCompletionToggled`: This toggles a todo's completed status.
- `TodosOverviewToggleAllRequested`: This toggles completion for all todos.
- `TodosOverviewClearCompletedRequested`: This deletes all completed todos.
- `TodosOverviewUndoDeletionRequested`: This undoes a todo deletion, e.g. an accidental deletion.
- `TodosOverviewFilterChanged`: This takes a `TodosViewFilter` as an argument and changes the view by applying a filter.

#### TodosOverviewState

Let's create `todos_overview/bloc/todos_overview_state.dart` and define the state.

[todos_overview_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/bloc/todos_overview_state.dart ':include')

`TodosOverviewState` will keep track of a list of todos, the active filter, the `lastDeletedTodo`, and the status.

?> **Note**: In addition to the default getters and setters, we have a custom getter called `filteredTodos`. The UI uses `BlocBuilder` to access either `state.filteredTodos` or `state.todos`.

#### TodosOverviewBloc

Let's create `todos_overview/bloc/todos_overview_bloc.dart`.

[todos_overview_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/bloc/todos_overview_bloc.dart ':include')

?> **Note**: The bloc does not create an instance of the `TodosRepository` internally. Instead, it relies on an instance of the repository to be injected via constructor.

##### onSubscriptionRequested

When `TodosOverviewSubscriptionRequested` is added, the bloc starts by emitting a `loading` state. In response, the UI can then render a loading indicator.

Next, we use `emit.forEach<List<Todo>>( ... )` which creates a subscription on the todos stream from the `TodosRepository`.

!> `emit.forEach()` is not the same `forEach()` used by lists. This `forEach` enables the bloc to subscribe to a `Stream` and emit a new state for each update from the stream.

?> **Note**: `stream.listen` is never called directly in this tutorial. Using `await emit.forEach()` is a newer pattern for subscribing to a stream which allows the bloc to manage the subscription internally.

Now that the subscription is handled, we will handle the other events, like adding, modifying, and deleting todos.

##### onTodoSaved

`_onTodoSaved` simply calls `_todosRepository.saveTodo(event.todo)`.

?> **Note**: `emit` is never called from within `onTodoSaved` and many other event handlers. Instead, they notify the repository which emits an updated list via the todos stream. See the [data flow](#data-flow) section for more information.

##### Undo

The undo feature allows users to restore the last deleted item.

`_onTodoDeleted` does two things. First, it emits a new state with the `Todo` to be deleted. Then, it deletes the `Todo` via a call to the repository.

`_onUndoDeletionRequested` runs when the undo deletion request event comes from the UI.

`_onUndoDeletionRequested` does the following:

- Temporarily saves a copy of the last deleted todo. 
- Updates the state by removing the `lastDeletedTodo`. 
- Reverts the deletion.

##### Filtering

`_onFilterChanged` emits a new state with the new event filter.

#### Models

There is one model file that deals with the view filtering.

`todos_view_filter.dart` is an enum that represents the three view filters and the methods to apply the filter.

[todos_view_filter.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/models/todos_view_filter.dart ':include')

`models.dart` is the barrel file for exports.

[models.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/models/models.dart ':include')

Next, let's take a look at the `TodosOverviewPage`.

#### TodosOverviewPage

[todos_overview_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/view/todos_overview_page.dart ':include')

A simplified representation of the widget tree for the `TodosOverviewPage` is:

```
├── TodosOverviewPage
│   └── BlocProvider<TodosOverviewBloc>
│       └── TodosOverviewView
│           ├── BlocListener<TodosOverviewBloc>
│           └── BlocListener<TodosOverviewBloc>
│               └── BlocBuilder<TodosOverviewBloc>
│                   └── ListView
```

Just as with the `Home` feature, the `TodosOverviewPage` provides an instance of the `TodosOverviewBloc` to the subtree via `BlocProvider<TodosOverviewBloc>`. This scopes the `TodosOverviewBloc` to just the widgets below `TodosOverviewPage`.

There are three widgets that are listening for changes in the `TodosOverviewBloc`.

1. The first is a `BlocListener` that listens for errors. The `listener` will only be called when `listenWhen` returns `true`. If the status is `TodosOverviewStatus.failure`, a `SnackBar` is displayed.

2. We created a second `BlocListener` that listens for deletions. When a todo has been deleted, a `SnackBar` is displayed with an undo button. If the user taps undo, the `TodosOverviewUndoDeletionRequested` event will be added to the bloc.

3. Finally, we use a `BlocBuilder` to builds the ListView that displays the todos.

The `AppBar`contains two actions which are dropdowns for filtering and manipulating the todos.

?> **Note**: `TodosOverviewTodoCompletionToggled` and `TodosOverviewTodoDeleted` are added to the bloc via `context.read`.

`view.dart` is the barrel file that exports `todos_overview_page.dart`.

[view.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/view/view.dart ':include')

#### Widgets

`widgets.dart` is another barrel file that exports all the components used within the `todos_overview` feature.

[widgets.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/widgets/widgets.dart ':include')

`todo_list_tile.dart` is the `ListTile` for each todo item.

[todo_list_tile.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/widgets/todo_list_tile.dart ':include')

`todos_overview_options_button.dart` exposes two options for manipulating todos:
  - `toggleAll`
  - `clearCompleted`

[todos_overview_options_button.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/widgets/todos_overview_options_button.dart ':include')

`todos_overview_filter_button.dart` exposes three filter options:
  - `all`
  - `activeOnly`
  - `completedOnly`

[todos_overview_filter_button.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/todos_overview/widgets/todos_overview_filter_button.dart ':include')

### Stats

The stats feature displays statistics about the active and completed todos.

#### StatsState

`StatsState` keeps track of summary information and the current `StatsStatus`.

[stats_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/stats/bloc/stats_state.dart ':include')

#### StatsEvent

`StatsEvent` has only one event called `StatsSubscriptionRequested`: 

[stats_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/stats/bloc/stats_event.dart ':include')

#### StatsBloc

`StatsBloc` depends on the `TodosRepository` just like `TodosOverviewBloc`. It subscribes to the todos stream via `_todosRepository.getTodos`.

[stats_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/stats/bloc/stats_bloc.dart ':include')

#### Stats View

`view.dart` is the barrel file for the `stats_page`.

[view.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/stats/view/view.dart ':include')

`stats_page.dart` contains the UI for the page that displays the todos statistics.

[stats_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/stats/view/stats_page.dart ':include')

A simplified representation of the widget tree for the `StatsPage` is:

```
├── StatsPage
│   └── BlocProvider<StatsBloc>
│       └── StatsView
│           ├── context.watch<StatsBloc>
│           └── Column
```

!> The `TodosOverviewBloc` and `StatsBloc` both communicate with the `TodosRepository`, but it is important to note there is no direct communication between the blocs. See the [data flow](#data-flow) section for more information.

### EditTodo

The `EditTodo` feature allows users to edit an existing todo item and save the changes.

#### EditTodoState

`EditTodoState` keeps track of the information needed when editing a todo.

[edit_todo_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/edit_todo/bloc/edit_todo_state.dart ':include')

#### EditTodoEvent

The different events the bloc will react to are:

- `EditTodoTitleChanged`
- `EditTodoDescriptionChanged`
- `EditTodoSubmitted`

[edit_todo_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/edit_todo/bloc/edit_todo_event.dart ':include')

#### EditTodoBloc

`EditTodoBloc` depends on the `TodosRepository`, just like `TodosOverviewBloc` and `StatsBloc`. 

!> Unlike the other Blocs, `EditTodoBloc` does not subscribe to `_todosRepository.getTodos`. It is a "write-only" bloc meaning it doesn't need to read any information from the repository.

[edit_todo_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/edit_todo/bloc/edit_todo_bloc.dart ':include')

##### Data Flow

Even though there are many features that depend on the same list of todos, there is no bloc-to-bloc communication. Instead, all features are independent of each other and rely on the `TodosRepository` to listen for changes in the list of todos, as well as perform updates to the list.

For example, the `EditTodos` doesn't know anything about the `TodosOverview` or `Stats` features.

When the UI submits a `EditTodoSubmitted` event:

- `EditTodoBloc` handles the business logic to update the `TodosRepository`.
- `TodosRepository` notifies `TodosOverviewBloc` and `StatsBloc`.
- `TodosOverviewBloc` and `StatsBloc` notify the UI which update with the new state.

#### EditTodoPage

[edit_todo_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_todos/lib/edit_todo/view/edit_todo_page.dart ':include')

Just like with the previous features, the `EditTodosPage` provides an instance of the `EditTodosBloc` via `BlocProvider`. Unlike the other features, the `EditTodosPage` is a separate route which is why it exposes a `static` `route` method. This makes it easy to push the `EditTodosPage` onto the navigation stack via `Navigator.of(context).push(...)`.

A simplified representation of the widget tree for the `EditTodosPage` is:

```
├── BlocProvider<EditTodosBloc>
│   └── EditTodosPage
│       └── BlocListener<EditTodosBloc>
│           └── EditTodosView
│               ├── TitleField
│               ├── DescriptionField
│               └── Floating Action Button
```

## Summary

That's it, we have completed the tutorial! 🎉

The full source code for this example, including unit and widget tests, can be found [here](https://github.com/felangel/bloc/tree/master/examples/flutter_todos).

# Flutter Weather Tutorial

![advanced](https://img.shields.io/badge/level-advanced-red.svg)

> In this tutorial, we're going to build a Weather app in Flutter which demonstrates how to manage multiple cubits to implement dynamic theming, pull-to-refresh, and much more. Our weather app will pull live weather data from the public OpenMeteo API and demonstrate how to separate our application into layers (data, repository, business logic, and presentation).

![demo](./assets/gifs/flutter_weather.gif)

## Project Requirements

Our app should let users
- Search for a city on a dedicated search page
- See a pleasant depiction of the weather data returned by [Open Meteo API](https://open-meteo.com)
- Change the units displayed (metric vs imperial)

Additionally,
- The theme of the application should reflect the weather for the chosen city
- Application state should persist across sessions: i.e., the app should remember its state after closing and reopening it (using [HydratedBloc](https://github.com/felangel/bloc/tree/master/packages/hydrated_bloc))

## Key Concepts

- Observe state changes with [BlocObserver](/coreconcepts?id=blocobserver)
- [BlocProvider](/flutterbloccoreconcepts?id=blocprovider), Flutter widget that provides a bloc to its children
- [BlocBuilder](/flutterbloccoreconcepts?id=blocbuilder), Flutter widget that handles building the widget in response to new states
- Prevent unnecessary rebuilds with [Equatable](/faqs?id=when-to-use-equatable)
- [RepositoryProvider](/flutterbloccoreconcepts?id=repositoryprovider), a Flutter widget that provides a repository to its children
- [BlocListener](/flutterbloccoreconcepts?id=bloclistener), a Flutter widget that invokes the listener code in response to state changes in the bloc
- [MultiBlocProvider](/flutterbloccoreconcepts?id=multiblocprovider), a Flutter widget that merges multiple BlocProvider widgets into one
- [BlocConsumer](/flutterbloccoreconcepts?id=blocconsumer), a Flutter widget that exposes a builder and listener in order to react to new states
- [HydratedBloc](https://github.com/felangel/bloc/tree/master/packages/hydrated_bloc) to manage and persist state

## Setup

To begin, create a new flutter project

[script](_snippets/flutter_weather_tutorial/flutter_create.sh.md ':include')

### Project Structure

> Our app will consist of isolated features in corresponding directories. This enables us to scale as the number of features increases and allows developers to work on different features in parallel.

Our app can be broken down into four main features: **search, settings, theme, weather**. Let's create those directories.

[script](_snippets/flutter_weather_tutorial/feature_tree.md ':include')

### Architecture

> Following the [bloc architecture](https://bloclibrary.dev/#/architecture) guidelines, our application will consist of several layers.

In this tutorial, here's what these layers will do:
- **Data**: retrieve raw weather data from the API
- **Repository**: abstract the data layer and expose domain models for the application to consume
- **Business Logic**: manage the state of each feature (unit information, city details, themes, etc.)
- **Presentation**: display weather information and collect input from users (settings page, search page etc.)

## Data Layer

For this application we'll be hitting the [Open Meteo API](https://open-meteo.com).

We'll be focusing on two endpoints:

- `https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1` to get a location for a given city name
- `https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true` to get the weather for a given location

Open [https://geocoding-api.open-meteo.com/v1/search?name=chicago&count=1](https://geocoding-api.open-meteo.com/v1/search?name=chicago&count=1) in your browser to see the response for the city of Chicago. We will use the `latitude` and `longitude` in the response to hit the weather endpoint.

The `latitude`/`longitutde` for Chicago is `41.85003`/`-87.65005`. Navigate to [https://api.open-meteo.com/v1/forecast?latitude=43.0389&longitude=-87.90647&current_weather=true](https://api.open-meteo.com/v1/forecast?latitude=43.0389&longitude=-87.90647&current_weather=true) in your browser and you'll see the response for weather in Chicago which contains all the data we will need for our app.

### OpenMeteo API Client

> The OpenMeteo API Client is independent of our application. As a result, we will create it as an internal package (and could even publish it on [pub.dev](https://pub.dev)). We can then use the package by adding it to the `pubspec.yaml` for the repository layer, which will handle data requests for our main weather application.

Create a new directory on the project level called `packages`. This directory will store all of our internal packages.

Within this directory, run the built-in `flutter create` command to create a new package called `open_meteo_api` for our API client.

[script](_snippets/flutter_weather_tutorial/data_layer/flutter_create_api_client.sh.md ':include')

### Weather Data Model

Next, let's create `location.dart` and `weather.dart` which will contain the models for the `location` and `weather` API endpoint responses.

[script](_snippets/flutter_weather_tutorial/data_layer/open_meteo_models_tree.md ':include')

#### Location Model

The `location.dart` model should store data returned by the location API, which looks like the following:

[location.json](_snippets/flutter_weather_tutorial/data_layer/location.json.md ':include')

Here's the in-progress `location.dart` file which stores the above response:

[location.dart](_snippets/flutter_weather_tutorial/data_layer/location.dart.md ':include')

#### Weather Model

Next, let's work on `weather.dart`. Our weather model should store data returned by the weather API, which looks like the following:

[weather.json](_snippets/flutter_weather_tutorial/data_layer/weather.json.md ':include')

Here's the in-progress `weather.dart` file which stores the above response:

[weather.dart](_snippets/flutter_weather_tutorial/data_layer/weather.dart.md ':include')

### Barrel Files

While we're here, let's quickly create a [barrel file](https://adrianfaciu.dev/posts/barrel-files/) to clean up some of our imports down the road.

Create a `models.dart` barrel file and export the two models:

[models.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/lib/src/models/models.dart ':include')

Let's also create a package level barrel file, `open_meteo_api.dart`

[script](_snippets/flutter_weather_tutorial/data_layer/open_meteo_models_barrel_tree.md ':include')

In the top level, `open_meteo_api.dart` let's export the models:

[open_meteo_api.dart](_snippets/flutter_weather_tutorial/data_layer/export_top_level_models.dart.md ':include')

### Setup

> We need to be able to [serialize and deserialize](https://en.wikipedia.org/wiki/Serialization) our models in order to work with the API data. To do this, we will add `toJson` and `fromJson` methods to our models.

> Additionally, we need a way to [make HTTP network requests](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods) to fetch data from an API. Fortunately, there are a number of popular packages for doing just that.

We will be using the [json_annotation](https://pub.dev/packages/json_annotation), [json_serializable](https://pub.dev/packages/json_serializable), and [build_runner](https://pub.dev/packages/build_runner) packages to generate the `toJson` and `fromJson` implementations for us.

In a later step, we will also use the [http](https://pub.dev/packages/http) package to send network requests to the MetaWeather API so our application can display the current weather data.

Let's add these dependencies to the `pubspec.yaml`.

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/pubspec.yaml ':include')

?> **Note**: Remember to run `flutter pub get` after adding the dependencies.

### (De)Serialization

In order for code generation to work, we need to annotate our code using the following:

- `@JsonSerializable` to label classes which can be serialized
- `@JsonKey` to provide string representations of field names
- `@JsonValue` to provide string representations of field values
- Implement `JSONConverter` to convert object representations into JSON representations

For each file we also need to:

- Import `json_annotation`
- Include the generated code using the [part](https://dart.dev/guides/libraries/create-library-packages#organizing-a-library-package) keyword
- Include `fromJson` methods for deserialization

#### Location Model

Here is our complete `location.dart` model file:

[location.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/lib/src/models/location.dart ':include')

#### Weather Model

Here is our complete `weather.dart` model file:

[weather.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/lib/src/models/weather.dart ':include')

#### Create Build File

In the `open_meteo_api` folder, create a `build.yaml` file. The purpose of this file is to handle discrepancies between naming conventions in the `json_serializable` field names.

[script](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/build.yaml ':include')

#### Code Generation

Let's use `build_runner` to generate the code.

[script](_snippets/flutter_weather_tutorial/build_runner_builder.sh.md ':include')

`build_runner` should generate the `location.g.dart` and `weather.g.dart` files.

### OpenMeteo API Client

Let's create our API client in `open_meteo_api_client.dart` within the `src` directory. Our project structure should now look like this:

[script](_snippets/flutter_weather_tutorial/data_layer/open_meteo_api_client_tree.md ':include')

We can now use the [http](https://pub.dev/packages/http) package we added earlier to the `pubspec.yaml` file to make HTTP requests to the Metaweather API and use this information in our application.

Our API client will expose two methods:

- `locationSearch` which returns a `Future<Location>`
- `getWeather` which returns a `Future<Weather>`

#### Location Search

The `locationSearch` method hits the location API and throws `LocationRequestFailure` errors as applicable. The completed method looks as follows:

[open_meteo_api_client.dart](_snippets/flutter_weather_tutorial/data_layer/location_search_method.dart.md ':include')

#### Get Weather

Similarly, the `getWeather` method hits the weather API and throws `WeatherRequestFailure` errors as applicable. The completed method looks as follows:

[open_meteo_api_client.dart](_snippets/flutter_weather_tutorial/data_layer/get_weather_method.dart.md ':include')

The completed file looks like this:

[open_meteo_api_client.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/lib/src/open_meteo_api_client.dart ':include')

#### Barrel File Updates

Let's wrap up this package by adding our API client to the barrel file.

[open_meteo_api.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/lib/open_meteo_api.dart ':include')

### Unit Tests

> It's especially important to write unit tests for the data layer since it's the foundation of our application. Unit tests will give us confidence that the package behaves as expected.

#### Setup

Earlier, we added the [test](https://pub.dev/packages/test) package to our pubspec.yaml which allows to easily write unit tests.

We will be creating a test file for the api client as well as the two models.

#### Location Tests

[location_test.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/test/location_test.dart ':include')

#### Weather Tests

[weather_test.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/test/weather_test.dart ':include')

#### API Client Tests

Next, let's test our API client. We should test to ensure that our API client handles both API calls correctly, including edge cases.

?> **Note**: We don't want our tests to make real API calls since our goal is to test the API client logic (including all edge cases) and not the API itself. In order to have a consistent, controlled test environment, we will use [mocktail](https://github.com/felangel/mocktail) (which we added to the pubspec.yaml file earlier) to mock the `http` client.

[open_meteo_api_client_test.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/open_meteo_api/test/open_meteo_api_client_test.dart ':include')

#### Test Coverage

Finally, let's gather test coverage to verify that we've covered each line of code with at least one test case.

[script](_snippets/flutter_weather_tutorial/test_coverage.sh.md ':include')

## Repository Layer

> The goal of our repository layer is to abstract our data layer and facilitate communication with the bloc layer. In doing this, the rest of our code base depends only on functions exposed by our repository layer instead of specific data provider implementations. This allows us to change data providers without disrupting any of the application-level code. For example, if we decide to migrate away from metaweather, we should be able to create a new API client and swap it out without having to make changes to the public API of the repository or application layers.

### Setup

Inside the packages directory, run the following command:

[script](_snippets/flutter_weather_tutorial/repository_layer/flutter_create_repository.sh.md ':include')

We will use the same packages as in the `open_meteo_api` package including the `open_meteo_api` package from the last step. Update your `pubspec.yaml` and run `flutter packages get`.

?> **Note**: We're using a `path` to specify the location of the `open_meteo_api` which allows us to treat it just like an external package from `pub.dev`.

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/weather_repository/pubspec.yaml ':include')

### Weather Repository Models

> We will be creating a new `weather.dart` file to expose a domain-specific weather model. This model will contain only data relevant to our business cases -- in other words it should be completely decoupled from the API client and raw data format. As usual, we will also create a `models.dart` barrel file.

[script](_snippets/flutter_weather_tutorial/repository_layer/repository_models_barrel_tree.md ':include')

This time, our weather model will only store the `location, temperature, condition` properties. We will also continue to annotate our code to allow for serialization and deserialization.

[weather.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/weather_repository/lib/src/models/weather.dart ':include')

Update the barrel file we created previously to include the models.

[models.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/weather_repository/lib/src/models/models.dart ':include')

#### Create Build File

As before, we need to create a `build.yaml` file with the following contents:

[script](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/weather_repository/build.yaml ':include')

#### Code Generation

As we have done previously, run the following command to generate the (de)serialization implementation.

[script](_snippets/flutter_weather_tutorial/build_runner_builder.sh.md ':include')

#### Barrel File

Let's also create a package-level barrel file named `packages/weather_repository/lib/weather_repository.dart` to export our models:

[script](_snippets/flutter_weather_tutorial/repository_layer/export_top_level_models.dart.md ':include')

### Weather Repository

> The main goal of the `WeatherRepository` is to provide an interface which abstracts the data provider. In this case, the `WeatherRepository` will have a dependency on the `WeatherApiClient` and expose a single public method, `getWeather(String city)`.

?> **Note**: Consumers of the `WeatherRepository` are not privy to the underlying implementation details such as the fact that two network requests are made to the metaweather API. The goal of the `WeatherRepository` is to separate the "what" from the "how" -- in other words, we want to have a way to fetch weather for a given city, but don't care about how or where that data is coming from.

#### Setup

Let's create the `weather_repository.dart` file within the `src` directory of our package and work on the repository implementation.

The main method we will focus on is `getWeather(String city)`. We can implement it using two calls to the API client as follows:

[weather_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/weather_repository/lib/src/weather_repository.dart ':include')

#### Barrel File

Update the barrel file we created previously.

[weather_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/weather_repository/lib/weather_repository.dart ':include')

### Unit Tests

> Just as with the data layer, it's critical to test the repository layer in order to make sure the domain level logic is correct. To test our `WeatherRepository`, we will use the [mocktail](https://github.com/felangel/mocktail) library. We will mock the underlying api client in order to unit test the `WeatherRepository` logic in an isolated, controlled environment.

[weather_repository_test.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/packages/weather_repository/test/weather_repository_test.dart ':include')

## Business Logic Layer

> In the business logic layer, we will be consuming the weather domain model from the `WeatherRepository` and exposing a feature-level model which will be surfaced to the user via the UI.

?> **Note**: This is the third different type of weather model we're implementing. In the API client, our weather model contained all the info returned by the API. In the repository layer, our weather model contained only the abstracted model based on our business case. In this layer, our weather model will contain relevant information needed specifically for the current feature set.

### Setup

Because our business logic layer resides in our main app, we need to edit the `pubspec.yaml` for the entire `flutter_weather` project and include all the packages we'll be using.

- Using [equatable](https://pub.dev/packages/equatable) enables our app's state class instances to be compared using the equals `==` operator. Under the hood, bloc will compare our states to see if they're equal, and if they're not, it will trigger a rebuild. This guarantees that our widget tree will only rebuild when necessary to keep performance fast and responsive.
- We can spice up our user interface with [google_fonts](https://pub.dev/packages/google_fonts).
- [HydratedBloc](https://pub.dev/packages/hydrated_bloc) allows us to persist application state when the app is closed and reopened.
- We'll include the `weather_repository` package we just created to allow us to fetch the current weather data!

For testing, we'll want to include the usual `test` package, along with `mocktail` for mocking dependencies and [bloc_test](https://pub.dev/packages/bloc_test), to enable easy testing of business logic units, or blocs!

[pubspec.yaml.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/pubspec.yaml ':include')

Next, we will be working on the application layer within the `weather` feature directory.

### Weather Model

> The goal of our weather model is to keep track of weather data displayed by our app, as well as temperature settings (Celsius or Fahrenheit).

Create `flutter_weather/lib/weather/models/weather.dart`:

[weather.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/models/weather.dart ':include')

### Create Build File

Create a `build.yaml` file for the business logic layer.

[script](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/build.yaml ':include')

### Code Generation

Run `build_runner` to generate the (de)serialization implementations.

[script](_snippets/flutter_weather_tutorial/build_runner_builder.sh.md ':include')

### Barrel File

Let's export our models from the barrel file (flutter_weather/lib/weather/models/models.dart):

[models.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/models/models.dart ':include')

### Weather

We will use `HydratedCubit` to enable our app to remember its application state, even after it's been closed and reopened.

?> **Note**: `HydratedCubit` is an extension of `Cubit` which handles persisting and restoring state across sessions.

#### Weather State

Using the [Bloc VSCode](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc) or [Bloc IntelliJ](https://plugins.jetbrains.com/plugin/12129-bloc) extension, right click on the `weather` directory and create a new cubit called `Weather`. The project structure should look like this:

[script](_snippets/flutter_weather_tutorial/business_logic_layer/weather_cubit_tree.md ':include')

There are four states our weather app can be in:

- `initial` before anything loads
- `loading` during the API call
- `success` if the API call is successful
- `failure` if the API call is unsuccessful

The `WeatherStatus` enum will represent the above.

The complete weather state should look like this:

[weather_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/cubit/weather_state.dart ':include')

#### Weather Cubit

Now that we've defined the `WeatherState`, let's write the `WeatherCubit` which will expose the following methods:

- `fetchWeather(String? city)` uses our weather repository to try and retrieve a weather object for the given city
- `refreshWeather()` retrieves a new weather object using the weather repository given the current weather state
- `toggleUnits()` toggles the state between Celsius and Fahrenheit
- `fromJson(Map<String, dynamic> json)`, `toJson(WeatherState state)` used for persistence

[weather_cubit.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/cubit/weather_cubit.dart ':include')

?> **Note**: Remember to generate the (de)serialization code via `flutter packages pub run build_runner build`

### Theme

Next, we'll implement the business logic for the dynamic theming.

#### Theme Cubit

Let's create a `ThemeCubit` to manage the theme of our app. The theme will change based on the current weather conditions.

[script](_snippets/flutter_weather_tutorial/business_logic_layer/theme_cubit_tree.md ':include')

We will expose an `updateTheme` method to update the theme depending on the weather condition.

[theme_cubit.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/theme/cubit/theme_cubit.dart ':include')

### Unit Tests

> Similar to the data and repository layers, it's critical to unit test the business logic layer to ensure that the feature-level logic behaves as we expect. We will be relying on the [bloc_test](https://pub.dev/packages/bloc_test) in addition to `mocktail` and `test`.

Let's add the `test`, `bloc_test`, and `mocktail` packages to the `dev_dependencies`.

[pubspec.yaml.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/pubspec.yaml ':include')

?> **Note**: The `bloc_test` package allows us to easily prepare our blocs for testing, handle state changes, and check results in a consistent way.

#### Theme Cubit Tests

[theme_cubit_test.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/test/theme/cubit/theme_cubit_test.dart ':include')

#### Weather Cubit Tests

[weather_cubit_test.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/test/weather/cubit/weather_cubit_test.dart ':include')

## Presentation Layer

### Weather Page

We will start with the `WeatherPage` which uses `BlocProvider` in order to provide an instance of the `WeatherCubit` to the widget tree.

[weather_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/view/weather_page.dart ':include')

You'll notice that page depends on `SettingsPage` and `SearchPage` widgets, which we will create next.

### SettingsPage

The settings page allows users to update their preferences for the temperature units.

[settings_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/settings/view/settings_page.dart ':include')

### SearchPage

The search page allows users to enter the name of their desired city and provides the search result to the previous route via `Navigator.of(context).pop`.

[search_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/search/view/search_page.dart ':include')

### Weather Widgets

The app will display different screens depending on the four possible states of the `WeatherCubit`.

#### WeatherEmpty

This screen will show when there is no data to display because the user has not yet selected a city.

[weather_empty.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/widgets/weather_empty.dart ':include')

#### WeatherError

This screen will display if there is an error.

[weather_error.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/widgets/weather_error.dart ':include')

#### WeatherLoading

This screen will display as the application fetches the data.

[weather_loading.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/widgets/weather_loading.dart ':include')

#### WeatherPopulated

This screen will display after the user has selected a city and we have retrieved the data.

[weather_populated.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/widgets/weather_populated.dart ':include')

### Barrel File

Let's add these states to a barrel file to clean up our imports.

[widgets.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/weather/widgets/widgets.dart ':include')

### Entrypoint

Our `main.dart` file should initialize our `WeatherApp` and `BlocObserver` (for debugging purposes), as well as setup our `HydratedStorage` to persist state across sessions.

[main.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/main.dart ':include')

Our `app.dart` widget will handle building the `WeatherPage` view we previously created and use `BlocProvider` to inject our `ThemeCubit` which handles theme data.

[app.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/lib/app.dart ':include')

### Widget Tests

The `bloc_test` library also exposes `MockBlocs` and `MockCubits` which make it easy to test UI. We can mock the states of the various cubits and ensure that the UI reacts correctly.

[weather_page_test.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_weather/test/weather/view/weather_page_test.dart ':include')

?> **Note**: We're using a `MockWeatherCubit` together with the `when` API from `mocktail` in order to stub the state of the cubit in each of the test cases. This allows us to simulate all states and verify the UI behaves correctly under all circumstances.

## Summary

That's it, we have completed the tutorial! 🎉

We can run the final app using the `flutter run` command.

The full source code for this example, including unit and widget tests, can be found [here](https://github.com/felangel/bloc/tree/master/examples/flutter_weather).

# Flutter Timer Tutorial

![beginner](https://img.shields.io/badge/level-beginner-green.svg)

> In the following tutorial we’re going to cover how to build a timer application using the bloc library. The finished application should look like this:

![demo](./assets/gifs/flutter_timer.gif)

## Key Topics

- Observe state changes with [BlocObserver](/coreconcepts?id=blocobserver).
- [BlocProvider](/flutterbloccoreconcepts?id=blocprovider), Flutter widget which provides a bloc to its children.
- [BlocBuilder](/flutterbloccoreconcepts?id=blocbuilder), Flutter widget that handles building the widget in response to new states.
- Prevent unnecessary rebuilds with [Equatable](/faqs?id=when-to-use-equatable).
- Learn to use `StreamSubscription` in a Bloc.
- Prevent unnecessary rebuilds with `buildWhen`.

## Setup

We’ll start off by creating a brand new Flutter project:

[script](_snippets/flutter_timer_tutorial/flutter_create.sh.md ':include')

We can then replace the contents of pubspec.yaml with:

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/pubspec.yaml ':include')

?> **Note:** We’ll be using the [flutter_bloc](https://pub.dev/packages/flutter_bloc) and [equatable](https://pub.dev/packages/equatable) packages in this app.

Next, run `flutter packages get` to install all the dependencies.

## Project Structure

```
├── lib
|   ├── timer
│   │   ├── bloc
│   │   │   └── timer_bloc.dart
|   |   |   └── timer_event.dart
|   |   |   └── timer_state.dart
│   │   └── view
│   │   |   ├── timer_page.dart
│   │   ├── timer.dart
│   ├── app.dart
│   ├── ticker.dart
│   └── main.dart
├── pubspec.lock
├── pubspec.yaml
```

## Ticker

> The ticker will be our data source for the timer application. It will expose a stream of ticks which we can subscribe and react to.

Start off by creating `ticker.dart`.

[ticker.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/lib/ticker.dart ':include')

All our `Ticker` class does is expose a tick function which takes the number of ticks (seconds) we want and returns a stream which emits the remaining seconds every second.

Next up, we need to create our `TimerBloc` which will consume the `Ticker`.

## Timer Bloc

### TimerState

We’ll start off by defining the `TimerStates` which our `TimerBloc` can be in.

Our `TimerBloc` state can be one of the following:

- TimerInitial — ready to start counting down from the specified duration.
- TimerRunInProgress — actively counting down from the specified duration.
- TimerRunPause — paused at some remaining duration.
- TimerRunComplete — completed with a remaining duration of 0.

Each of these states will have an implication on the user interface and actions that the user can perform. For example:

- if the state is `TimerInitial` the user will be able to start the timer.
- if the state is `TimerRunInProgress` the user will be able to pause and reset the timer as well as see the remaining duration.
- if the state is `TimerRunPause` the user will be able to resume the timer and reset the timer.
- if the state is `TimerRunComplete` the user will be able to reset the timer.

In order to keep all of our bloc files together, let’s create a bloc directory with `bloc/timer_state.dart`.

?> **Tip:** You can use the [IntelliJ](https://plugins.jetbrains.com/plugin/12129-bloc-code-generator) or [VSCode](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc) extensions to autogenerate the following bloc files for you.

[timer_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/lib/timer/bloc/timer_state.dart ':include')

Note that all of the `TimerStates` extend the abstract base class `TimerState` which has a duration property. This is because no matter what state our `TimerBloc` is in, we want to know how much time is remaining. Additionally, `TimerState` extends `Equatable` to optimize our code by ensuring that our app does not trigger rebuilds if the same state occurs. 

Next up, let’s define and implement the `TimerEvents` which our `TimerBloc` will be processing.

### TimerEvent

Our `TimerBloc` will need to know how to process the following events:

- TimerStarted — informs the TimerBloc that the timer should be started.
- TimerPaused — informs the TimerBloc that the timer should be paused.
- TimerResumed — informs the TimerBloc that the timer should be resumed.
- TimerReset — informs the TimerBloc that the timer should be reset to the original state.
- _TimerTicked — informs the TimerBloc that a tick has occurred and that it needs to update its state accordingly.

If you didn’t use the [IntelliJ](https://plugins.jetbrains.com/plugin/12129-bloc-code-generator) or [VSCode](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc) extensions, then create `bloc/timer_event.dart` and let’s implement those events.

[timer_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/lib/timer/bloc/timer_event.dart ':include')

Next up, let’s implement the `TimerBloc`!

### TimerBloc

If you haven’t already, create `bloc/timer_bloc.dart` and create an empty `TimerBloc`.

[timer_bloc.dart](_snippets/flutter_timer_tutorial/timer_bloc_empty.dart.md ':include')

The first thing we need to do is define the initial state of our `TimerBloc`. In this case, we want the `TimerBloc` to start off in the `TimerInitial` state with a preset duration of 1 minute (60 seconds).

[timer_bloc.dart](_snippets/flutter_timer_tutorial/timer_bloc_initial_state.dart.md ':include')

Next, we need to define the dependency on our `Ticker`.

[timer_bloc.dart](_snippets/flutter_timer_tutorial/timer_bloc_ticker.dart.md ':include')

We are also defining a `StreamSubscription` for our `Ticker` which we will get to in a bit.

At this point, all that’s left to do is implement the event handlers. For improved readability, I like to break out each event handler into its own helper function. We’ll start with the `TimerStarted` event.

[timer_bloc.dart](_snippets/flutter_timer_tutorial/timer_bloc_start.dart.md ':include')

If the `TimerBloc` receives a `TimerStarted` event, it pushes a `TimerRunInProgress` state with the start duration. In addition, if there was already an open `_tickerSubscription` we need to cancel it to deallocate the memory. We also need to override the `close` method on our `TimerBloc` so that we can cancel the `_tickerSubscription` when the `TimerBloc` is closed. Lastly, we listen to the `_ticker.tick` stream and on every tick we add a `_TimerTicked` event with the remaining duration.

Next, let’s implement the `_TimerTicked` event handler.

[timer_bloc.dart](_snippets/flutter_timer_tutorial/timer_bloc_tick.dart.md ':include')

Every time a `_TimerTicked` event is received, if the tick’s duration is greater than 0, we need to push an updated `TimerRunInProgress` state with the new duration. Otherwise, if the tick’s duration is 0, our timer has ended and we need to push a `TimerRunComplete` state.

Now let’s implement the `TimerPaused` event handler.

[timer_bloc.dart](_snippets/flutter_timer_tutorial/timer_bloc_pause.dart.md ':include')

In `_onPaused` if the `state` of our `TimerBloc` is `TimerRunInProgress`, then we can pause the `_tickerSubscription` and push a `TimerRunPause` state with the current timer duration.

Next, let’s implement the `TimerResumed` event handler so that we can unpause the timer.

[timer_bloc.dart](_snippets/flutter_timer_tutorial/timer_bloc_resume.dart.md ':include')

The `TimerResumed` event handler is very similar to the `TimerPaused` event handler. If the `TimerBloc` has a `state` of `TimerRunPause` and it receives a `TimerResumed` event, then it resumes the `_tickerSubscription` and pushes a `TimerRunInProgress` state with the current duration.

Lastly, we need to implement the `TimerReset` event handler.

[timer_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/lib/timer/bloc/timer_bloc.dart ':include')

If the `TimerBloc` receives a `TimerReset` event, it needs to cancel the current `_tickerSubscription` so that it isn’t notified of any additional ticks and pushes a `TimerInitial` state with the original duration.

That’s all there is to the `TimerBloc`. Now all that’s left is implement the UI for our Timer Application.

## Application UI

### MyApp

We can start off by deleting the contents of `main.dart` and replacing it with the following.

[main.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/lib/main.dart ':include')

Next, let's create our 'App' widget in `app.dart`, which will be the root of our application.

[app.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/lib/app.dart ':include')

Next, we need to implement our `Timer` widget.

### Timer

Our `Timer` widget (`/timer/view/timer_page.dart`) will be responsible for displaying the remaining time along with the proper buttons which will enable users to start, pause, and reset the timer.

[timer.dart](_snippets/flutter_timer_tutorial/timer1.dart.md ':include')

So far, we’re just using `BlocProvider` to access the instance of our `TimerBloc`.

Next, we’re going to implement our `Actions` widget which will have the proper actions (start, pause, and reset).

### Barrel

In order to clean up our imports from the `Timer` section, we need to create a barrel file `timer/timer.dart`.

[timer.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_timer/lib/timer/timer.dart ':include')

### Actions

[actions.dart](_snippets/flutter_timer_tutorial/actions.dart.md ':include')

The `Actions` widget is just another `StatelessWidget` which uses a `BlocBuilder` to rebuild the UI every time we get a new `TimerState`. `Actions` uses `context.read<TimerBloc>()` to access the `TimerBloc` instance and returns different `FloatingActionButtons` based on the current state of the `TimerBloc`. Each of the `FloatingActionButtons` adds an event in its `onPressed` callback to notify the `TimerBloc`.

If you want fine-grained control over when the `builder` function is called you can provide an optional `buildWhen` to `BlocBuilder`. The `buildWhen` takes the previous bloc state and current bloc state and returns a `boolean`. If `buildWhen` returns `true`, `builder` will be called with `state` and the widget will rebuild. If `buildWhen` returns `false`, `builder` will not be called with `state` and no rebuild will occur.

In this case, we don’t want the `Actions` widget to be rebuilt on every tick because that would be inefficient. Instead, we only want `Actions` to rebuild if the `runtimeType` of the `TimerState` changes (TimerInitial => TimerRunInProgress, TimerRunInProgress => TimerRunPause, etc...).

As a result, if we randomly colored the widgets on every rebuild, it would look like:

![BlocBuilder buildWhen demo](https://cdn-images-1.medium.com/max/1600/1*YyjpH1rcZlYWxCX308l_Ew.gif)

?> **Notice:** Even though the `Text` widget is rebuilt on every tick, we only rebuild the `Actions` if they need to be rebuilt.

### Background

Lastly, add the background widget as follows:

[background.dart](_snippets/flutter_timer_tutorial/background.dart.md ':include')

### Putting it all together

That’s all there is to it! At this point we have a pretty solid timer application which efficiently rebuilds only widgets that need to be rebuilt.

The full source for this example can be found [here](https://github.com/felangel/Bloc/tree/master/examples/flutter_timer).

# Flutter Login Tutorial

![intermediate](https://img.shields.io/badge/level-intermediate-orange.svg)

> In the following tutorial, we're going to build a Login Flow in Flutter using the Bloc library.

![demo](./assets/gifs/flutter_login.gif)

## Key Topics

- [BlocProvider](/flutterbloccoreconcepts?id=blocprovider), Flutter widget which provides a bloc to its children.
- [BlocBuilder](/flutterbloccoreconcepts?id=blocbuilder), Flutter widget that handles building the widget in response to new states.
- Using Cubit and Bloc. [What's the difference?](/coreconcepts?id=cubit-vs-bloc)
- Adding events with [context.read](/migration?id=❗contextbloc-and-contextrepository-are-deprecated-in-favor-of-contextread-and-contextwatch).⚡
- Prevent unnecessary rebuilds with [Equatable](/faqs?id=when-to-use-equatable).
- [RepositoryProvider](/flutterbloccoreconcepts?id=repositoryprovider), a Flutter widget which provides a repository to its children.
- [BlocListener](/flutterbloccoreconcepts?id=bloclistener), a Flutter widget which invokes the listener code in response to state changes in the bloc.
- Updating the UI based on a part of a bloc state with [context.select](/migration?id=❗contextbloc-and-contextrepository-are-deprecated-in-favor-of-contextread-and-contextwatch).⚡

## Project Setup

We'll start off by creating a brand new Flutter project

```sh
flutter create flutter_login
```

Next, we can install all of our dependencies

```sh
flutter packages get
```

## Authentication Repository

The first thing we're going to do is create an `authentication_repository` package which will be responsible for managing the authentication domain.

We'll start by creating a `packages/authentication_repository` directory at the root of the project which will contain all internal packages.

At a high level, the directory structure should look like this:

```sh
├── android
├── ios
├── lib
├── packages
│   └── authentication_repository
└── test
```

Next, we can create a `pubspec.yaml` for the `authentication_repository` package:

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/authentication_repository/pubspec.yaml ':include')

?> **Note**: `package:authentication_repository` will be a pure Dart package and for simplicity we will only have a dependency on [package:meta](https://pub.dev/packages/meta) for some useful annotations.

Next up, we need to implement the `AuthenticationRepository` class itself which will be in `packages/authentication_repository/lib/src/authentication_repository.dart`.

[authentication_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/authentication_repository/lib/src/authentication_repository.dart ':include')

The `AuthenticationRepository` exposes a `Stream` of `AuthenticationStatus` updates which will be used to notify the application when a user signs in or out.

In addition, there are `logIn` and `logOut` methods which are stubbed for simplicity but can easily be extended to authenticate with `FirebaseAuth` for example or some other authentication provider.

?> **Note**: Since we are maintaining a `StreamController` internally, a `dispose` method is exposed so that the controller can be closed when it is no longer needed.

Lastly, we need to create `packages/authentication_repository/lib/authentication_repository.dart` which will contain the public exports:

[authentication_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/authentication_repository/lib/authentication_repository.dart ':include')

That's it for the `AuthenticationRepository`, next we'll work on the `UserRepository`.

## User Repository

Just like with the `AuthenticationRepository`, we will create a `user_repository` package inside the `packages` directory.

```sh
├── android
├── ios
├── lib
├── packages
│   ├── authentication_repository
│   └── user_repository
└── test
```

Next, we'll create the `pubspec.yaml` for the `user_repository`:

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/user_repository/pubspec.yaml ':include')

The `user_repository` will be responsible for the user domain and will expose APIs to interact with the current user.

The first thing we will define is the user model in `packages/user_repository/lib/src/models/user.dart`:

[user.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/user_repository/lib/src/models/user.dart ':include')

For simplicity, a user just has an `id` property but in practice we might have additional properties like `firstName`, `lastName`, `avatarUrl`, etc...

?> **Note**: [package:equatable](https://pub.dev/packages/equatable) is used to enable value comparisons of the `User` object.

Next, we can create a `models.dart` in `packages/user_repository/lib/src/models` which will export all models so that we can use a single import state to import multiple models.

[models.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/user_repository/lib/src/models/models.dart ':include')

Now that the models have been defined, we can implement the `UserRepository` class in `packages/user_repository/lib/src/user_repository.dart`.

[user_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/user_repository/lib/src/user_repository.dart ':include')

For this simple example, the `UserRepository` exposes a single method `getUser` which will retrieve the current user. We are stubbing this but in practice this is where we would query the current user from the backend.

Almost done with the `user_repository` package -- the only thing left to do is to create the `user_repository.dart` file in `packages/user_repository/lib` which defines the public exports:

[user_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/packages/user_repository/lib/user_repository.dart ':include')

Now that we have the `authentication_repository` and `user_repository` packages complete, we can focus on the Flutter application.

## Installing Dependencies

Let's start by updating the generated `pubspec.yaml` at the root of our project:

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/pubspec.yaml ':include')

We can install the dependencies by running:

```sh
flutter packages get
```

## Authentication Bloc

The `AuthenticationBloc` will be responsible for reacting to changes in the authentication state (exposed by the `AuthenticationRepository`) and will emit states we can react to in the presentation layer.

The implementation for the `AuthenticationBloc` is inside of `lib/authentication` because we treat authentication as a feature in our application layer.

```sh
├── lib
│   ├── app.dart
│   ├── authentication
│   │   ├── authentication.dart
│   │   └── bloc
│   │       ├── authentication_bloc.dart
│   │       ├── authentication_event.dart
│   │       └── authentication_state.dart
│   ├── main.dart
```

?> **Tip**: Use the [VSCode Extension](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc) or [IntelliJ Plugin](https://plugins.jetbrains.com/plugin/12129-bloc) to create blocs automatically.

### authentication_event.dart

> `AuthenticationEvent` instances will be the input to the `AuthenticationBloc` and will be processed and used to emit new `AuthenticationState` instances.

In this application, the `AuthenticationBloc` will be reacting to two different events:

- `AuthenticationStatusChanged`: notifies the bloc of a change to the user's `AuthenticationStatus`
- `AuthenticationLogoutRequested`: notifies the bloc of a logout request

[authentication_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/authentication/bloc/authentication_event.dart ':include')

Next, let's take a look at the `AuthenticationState`.

### authentication_state.dart

> `AuthenticationState` instances will be the output of the `AuthenticationBloc` and will be consumed by the presentation layer.

The `AuthenticationState` class has three named constructors:

- `AuthenticationState.unknown()`: the default state which indicates that the bloc does not yet know whether the current user is authenticated or not.

- `AuthenticationState.authenticated()`: the state which indicates that the user is current authenticated.

- `AuthenticationState.unauthenticated()`: the state which indicates that the user is current not authenticated.

[authentication_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/authentication/bloc/authentication_state.dart ':include')

Now that we have seen the `AuthenticationEvent` and `AuthenticationState` implementations let's take a look at `AuthenticationBloc`.

### authentication_bloc.dart

> The `AuthenticationBloc` manages the authentication state of the application which is used to determine things like whether or not to start the user at a login page or a home page.

[authentication_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/authentication/bloc/authentication_bloc.dart ':include')

The `AuthenticationBloc` has a dependency on both the `AuthenticationRepository` and `UserRepository` and defines the initial state as `AuthenticationState.unknown()`.

In the constructor body, the `AuthenticationBloc` subscribes to the `status` stream of the `AuthenticationRepository` and adds an `AuthenticationStatusChanged` event internally in response to a new `AuthenticationStatus`.

!> The `AuthenticationBloc` overrides `close` in order to dispose both the `StreamSubscription` as well as the `AuthenticationRepository`.

Next, the `EventHandler` handles transforming the incoming `AuthenticationEvent` instances into new `AuthenticationState` instances.

When an `AuthenticationStatusChanged` event is added if the associated status is `AuthenticationStatus.authenticated`, the `AuthentictionBloc` queries the user via the `UserRepository`.

## main.dart

Next, we can replace the default `main.dart` with:

[main.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/main.dart ':include')

?> **Note**: We are injecting a single instance of the `AuthenticationRepository` and `UserRepository` into the `App` widget (which we will get to next).

## App

`app.dart` will contain the root `App` widget for the entire application.

[app.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/app.dart ':include')

?> **Note**: `app.dart` is split into two parts `App` and `AppView`. `App` is responsible for creating/providing the `AuthenticationBloc` which will be consumed by the `AppView`. This decoupling will enable us to easily test both the `App` and `AppView` widgets later on.

?> **Note**: `RepositoryProvider` is used to provide the single instance of `AuthenticationRepository` to the entire application which will come in handy later on.

`AppView` is a `StatefulWidget` because it maintains a `GlobalKey` which is used to access the `NavigatorState`. By default, `AppView` will render the `SplashPage` (which we will see later) and it uses `BlocListener` to navigate to different pages based on changes in the `AuthenticationState`.

## Splash

> The splash feature will just contain a simple view which will be rendered right when the app is launched while the app determines whether the user is authenticated.

```sh
lib
└── splash
    ├── splash.dart
    └── view
        └── splash_page.dart
```

[splash_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/splash/view/splash_page.dart ':include')

?> **Tip**: `SplashPage` exposes a static `Route` which makes it very easy to navigate to via `Navigator.of(context).push(SplashPage.route())`;

## Login

> The login feature contains a `LoginPage`, `LoginForm` and `LoginBloc` and allows users to enter a username and password to log into the application.

```sh
├── lib
│   ├── login
│   │   ├── bloc
│   │   │   ├── login_bloc.dart
│   │   │   ├── login_event.dart
│   │   │   └── login_state.dart
│   │   ├── login.dart
│   │   ├── models
│   │   │   ├── models.dart
│   │   │   ├── password.dart
│   │   │   └── username.dart
│   │   └── view
│   │       ├── login_form.dart
│   │       ├── login_page.dart
│   │       └── view.dart
```

### Login Models

We are using [package:formz](https://pub.dev/packages/formz) to create reusable and standard models for the `username` and `password`.

#### Username

[username.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/models/username.dart ':include')

For simplicity, we are just validating the username to ensure that it is not empty but in practice you can enforce special character usage, length, etc...

#### Password

[password.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/models/password.dart ':include')

Again, we are just performing a simple check to ensure the password is not empty.

#### Models Barrel

Just like before, there is a `models.dart` barrel to make it easy to import the `Username` and `Password` models with a single import.

[models.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/models/models.dart ':include')

### Login Bloc

> The `LoginBloc` manages the state of the `LoginForm` and takes care validating the username and password input as well as the state of the form.

#### login_event.dart

In this application there are three different `LoginEvent` types:

- `LoginUsernameChanged`: notifies the bloc that the username has been modified.
- `LoginPasswordChanged`: notifies the bloc that the password has been modified.
- `LoginSubmitted`: notifies the bloc that the form has been submitted.

[login_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/bloc/login_event.dart ':include')

#### login_state.dart

The `LoginState` will contain the status of the form as well as the username and password input states.

[login_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/bloc/login_state.dart ':include')

?> **Note**: The `Username` and `Password` models are used as part of the `LoginState` and the status is also part of [package:formz](https://pub.dev/packages/formz).

#### login_bloc.dart

> The `LoginBloc` is responsible for reacting to user interactions in the `LoginForm` and handling the validation and submission of the form.

[login_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/bloc/login_bloc.dart ':include')

The `LoginBloc` has a dependency on the `AuthenticationRepository` because when the form is submitted, it invokes `logIn`. The initial state of the bloc is `pure` meaning neither the inputs nor the form has been touched or interacted with.

Whenever either the `username` or `password` change, the bloc will create a dirty variant of the `Username`/`Password` model and update the form status via the `Formz.validate` API.

When the `LoginSubmitted` event is added, if the current status of the form is valid, the bloc makes a call to `logIn` and updates the status based on the outcome of the request.

Next let's take a look at the `LoginPage` and `LoginForm`.

### Login Page

> The `LoginPage` is responsible for exposing the `Route` as well as creating and providing the `LoginBloc` to the `LoginForm`.

[login_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/view/login_page.dart ':include')

?> **Note**: `RepositoryProvider.of<AuthenticationRepository>(context)` is used to lookup the instance of `AuthenticationRepository` via the `BuildContext`.

### Login Form

> The `LoginForm` handles notifying the `LoginBloc` of user events and also responds to state changes using `BlocBuilder` and `BlocListener`.

[login_form.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/login/view/login_form.dart ':include')

`BlocListener` is used to show a `SnackBar` if the login submission fails. In addition, `BlocBuilder` widgets are used to wrap each of the `TextField` widgets and make use of the `buildWhen` property in order to optimize for rebuilds. The `onChanged` callback is used to notify the `LoginBloc` of changes to the username/password.

The `_LoginButton` widget is only enabled if the status of the form is valid and a `CircularProgressIndicator` is shown in its place while the form is being submitted.

## Home

> Upon a successful `logIn` request, the state of the `AuthenticationBloc` will change to `authenticated` and the user will be navigated to the `HomePage` where we display the user's `id` as well as a button to log out.

```sh
├── lib
│   ├── home
│   │   ├── home.dart
│   │   └── view
│   │       └── home_page.dart
```

### Home Page

The `HomePage` can access the current user id via `context.select((AuthenticationBloc bloc) => bloc.state.user.id)` and displays it via a `Text` widget. In addition, when the logout button is tapped, an `AuthenticationLogoutRequested` event is added to the `AuthenticationBloc`.

[home_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_login/lib/home/view/home_page.dart ':include')

?> **Note**: `context.select((AuthenticationBloc bloc) => bloc.state.user.id)` will trigger updates if the user id changes.

At this point we have a pretty solid login implementation and we have decoupled our presentation layer from the business logic layer by using Bloc.

The full source for this example (including unit and widget tests) can be found [here](https://github.com/felangel/Bloc/tree/master/examples/flutter_login).

# Flutter Infinite List Tutorial

![intermediate](https://img.shields.io/badge/level-intermediate-orange.svg)

> In this tutorial, we’re going to be implementing an app which fetches data over the network and loads it as a user scrolls using Flutter and the bloc library.

![demo](./assets/gifs/flutter_infinite_list.gif)

## Key Topics

- Observe state changes with [BlocObserver](/coreconcepts?id=blocobserver).
- [BlocProvider](/flutterbloccoreconcepts?id=blocprovider), Flutter widget which provides a bloc to its children.
- [BlocBuilder](/flutterbloccoreconcepts?id=blocbuilder), Flutter widget that handles building the widget in response to new states.
- Adding events with [context.read](/migration?id=❗contextbloc-and-contextrepository-are-deprecated-in-favor-of-contextread-and-contextwatch).⚡
- Prevent unnecessary rebuilds with [Equatable](/faqs?id=when-to-use-equatable).
- Use the `transformEvents` method with Rx.

## Setup

We’ll start off by creating a brand new Flutter project

```sh
flutter create flutter_infinite_list
```

We can then go ahead and replace the contents of pubspec.yaml with

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/pubspec.yaml ':include')

and then install all of our dependencies

```sh
flutter pub get
```

## Project Structure

```
├── lib
|   ├── posts
│   │   ├── bloc
│   │   │   └── post_bloc.dart
|   |   |   └── post_event.dart
|   |   |   └── post_state.dart
|   |   └── models
|   |   |   └── models.dart*
|   |   |   └── post.dart
│   │   └── view
│   │   |   ├── posts_page.dart
│   │   |   └── posts_list.dart
|   |   |   └── view.dart*
|   |   └── widgets
|   |   |   └── bottom_loader.dart
|   |   |   └── post_list_item.dart
|   |   |   └── widgets.dart*
│   │   ├── posts.dart*
│   ├── app.dart
│   ├── simple_bloc_observer.dart
│   └── main.dart
├── pubspec.lock
├── pubspec.yaml
```

The application uses a feature-driven directory structure. This project structure enables us to scale the project by having self-contained features. In this example we will only have a single feature (the post feature) and it's split up into respective folders with barrel files, indicated by the asterisk (\*).

## REST API

For this demo application, we’ll be using [jsonplaceholder](http://jsonplaceholder.typicode.com) as our data source.

?> jsonplaceholder is an online REST API which serves fake data; it’s very useful for building prototypes.

Open a new tab in your browser and visit https://jsonplaceholder.typicode.com/posts?_start=0&_limit=2 to see what the API returns.

[posts.json](_snippets/flutter_infinite_list_tutorial/posts.json.md ':include')

?> **Note:** in our url we specified the start and limit as query parameters to the GET request.

Great, now that we know what our data is going to look like, let’s create the model.

## Data Model

Create `post.dart` and let’s get to work creating the model of our Post object.

[post.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/models/post.dart ':include')

`Post` is just a class with an `id`, `title`, and `body`.

?> We extend [`Equatable`](https://pub.dev/packages/equatable) so that we can compare `Posts`. Without this, we would need to manually change our class to override equality and hashCode so that we could tell the difference between two `Posts` objects. See [the package](https://pub.dev/packages/equatable) for more details.

Now that we have our `Post` object model, let’s start working on the Business Logic Component (bloc).

## Post Events

Before we dive into the implementation, we need to define what our `PostBloc` is going to be doing.

At a high level, it will be responding to user input (scrolling) and fetching more posts in order for the presentation layer to display them. Let’s start by creating our `Event`.

Our `PostBloc` will only be responding to a single event; `PostFetched` which will be added by the presentation layer whenever it needs more Posts to present. Since our `PostFetched` event is a type of `PostEvent` we can create `bloc/post_event.dart` and implement the event like so.

[post_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/bloc/post_event.dart ':include')

To recap, our `PostBloc` will be receiving `PostEvents` and converting them to `PostStates`. We have defined all of our `PostEvents` (PostFetched) so next let’s define our `PostState`.

## Post States

Our presentation layer will need to have several pieces of information in order to properly lay itself out:

- `PostInitial`- will tell the presentation layer it needs to render a loading indicator while the initial batch of posts are loaded

- `PostSuccess`- will tell the presentation layer it has content to render
  - `posts`- will be the `List<Post>` which will be displayed
  - `hasReachedMax`- will tell the presentation layer whether or not it has reached the maximum number of posts
- `PostFailure`- will tell the presentation layer that an error has occurred while fetching posts

We can now create `bloc/post_state.dart` and implement it like so.

[post_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/bloc/post_state.dart ':include')

?> We implemented `copyWith` so that we can copy an instance of `PostSuccess` and update zero or more properties conveniently (this will come in handy later).

Now that we have our `Events` and `States` implemented, we can create our `PostBloc`.

## Post Bloc

For simplicity, our `PostBloc` will have a direct dependency on an `http client`; however, in a production application we suggest instead you inject an api client and use the repository pattern [docs](./architecture.md).

Let’s create `post_bloc.dart` and create our empty `PostBloc`.

[post_bloc_initial.dart](_snippets/flutter_infinite_list_tutorial/post_bloc_initial.dart.md ':include')

?> **Note:** Just from the class declaration we can tell that our PostBloc will be taking PostEvents as input and outputting PostStates.

Next, we need to register an event handler to handle incoming `PostFetched` events. In response to a `PostFetched` event, we will call `_fetchPosts` to fetch posts from the API.

[post_bloc_on_post_fetched.dart](_snippets/flutter_infinite_list_tutorial/post_bloc_on_post_fetched.dart.md ':include')

Our `PostBloc` will `emit` new states via the `Emitter<PostState>` provided in the event handler. Check out [core concepts](https://bloclibrary.dev/#/coreconcepts?id=streams) for more information.

Now every time a `PostEvent` is added, if it is a `PostFetched` event and there are more posts to fetch, our `PostBloc` will fetch the next 20 posts.

The API will return an empty array if we try to fetch beyond the maximum number of posts (100), so if we get back an empty array, our bloc will `emit` the currentState except we will set `hasReachedMax` to true.

If we cannot retrieve the posts, we throw an exception and `emit` `PostFailure()`.

If we can retrieve the posts, we return `PostSuccess()` which takes the entire list of posts.

One optimization we can make is to `debounce` the `Events` in order to prevent spamming our API unnecessarily. We can do this by overriding the `transform` method in our `PostBloc`.

?> **Note:** Passing a `transformer` to `on<PostFetched>` allows us to customize how events are processed.
?> **Note:** Make sure to import [`package:stream_transform`](https://pub.dev/packages/stream_transform) to use the `throttle` api.

[post_bloc_transformer.dart.dart](_snippets/flutter_infinite_list_tutorial/post_bloc_transformer.dart.md ':include')


Our finished `PostBloc` should now look like this:

[post_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/bloc/post_bloc.dart ':include')

Great! Now that we’ve finished implementing the business logic all that’s left to do is implement the presentation layer.

## Presentation Layer

In our `main.dart` we can start by implementing our main function and calling `runApp` to render our root widget. Here, we can also include our bloc observer to log transitions and any errors.

[main.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/main.dart ':include')

?> **Note:** `EquatableConfig.stringify = kDebugMode;` is a constant that affects the output of toString. When in debug mode, equatable's toString method will behave differently than profile and release mode and can use constants like kDebugMode or kReleaseMode to understand if you are running on debug or release.

In our `App` widget, the root of our project, we can then set the home to `PostsPage`

[app.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/app.dart ':include')

In our `PostsPage` widget, we use `BlocProvider` to create and provide an instance of `PostBloc` to the subtree. Also, we add a `PostFetched` event so that when the app loads, it requests the initial batch of Posts.

[posts_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/view/posts_page.dart ':include')

Next, we need to implement our `PostsList` view which will present our posts and hook up to our `PostBloc`.

[posts_list.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/view/posts_list.dart ':include')

?> `PostsList` is a `StatefulWidget` because it will need to maintain a `ScrollController`. In `initState`, we add a listener to our `ScrollController` so that we can respond to scroll events. We also access our `PostBloc` instance via `context.read<PostBloc>()`.

Moving along, our build method returns a `BlocBuilder`. `BlocBuilder` is a Flutter widget from the [flutter_bloc package](https://pub.dev/packages/flutter_bloc) which handles building a widget in response to new bloc states. Any time our `PostBloc` state changes, our builder function will be called with the new `PostState`.

!> We need to remember to clean up after ourselves and dispose of our `ScrollController` when the StatefulWidget is disposed.

Whenever the user scrolls, we calculate how far you have scrolled down the page and if our distance is ≥ 90% of our `maxScrollextent` we add a `PostFetched` event in order to load more posts.

Next, we need to implement our `BottomLoader` widget which will indicate to the user that we are loading more posts.

[bottom_loader.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/widgets/bottom_loader.dart ':include')

Lastly, we need to implement our `PostListItem` which will render an individual Post.

[post_list_item.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/posts/widgets/post_list_item.dart ':include')

At this point, we should be able to run our app and everything should work; however, there’s one more thing we can do.

One added bonus of using the bloc library is that we can have access to all `Transitions` in one place.

> The change from one state to another is called a `Transition`.

?> A `Transition` consists of the current state, the event, and the next state.

Even though in this application we only have one bloc, it's fairly common in larger applications to have many blocs managing different parts of the application's state.

If we want to be able to do something in response to all `Transitions` we can simply create our own `BlocObserver`.

[simple_bloc_observer.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_infinite_list/lib/simple_bloc_observer.dart ':include')

?> All we need to do is extend `BlocObserver` and override the `onTransition` method.

Now every time a Bloc `Transition` occurs we can see the transition printed to the console.

?> In practice, you can create different `BlocObservers` and because every state change is recorded, we are able to very easily instrument our applications and track all user interactions and state changes in one place!

That’s all there is to it! We’ve now successfully implemented an infinite list in flutter using the [bloc](https://pub.dev/packages/bloc) and [flutter_bloc](https://pub.dev/packages/flutter_bloc) packages and we’ve successfully separated our presentation layer from our business logic.

Our `PostsPage` has no idea where the `Posts` are coming from or how they are being retrieved. Conversely, our `PostBloc` has no idea how the `State` is being rendered, it simply converts events into states.

The full source for this example can be found [here](https://github.com/felangel/Bloc/tree/master/examples/flutter_infinite_list).

# Flutter Firebase Login Tutorial

![advanced](https://img.shields.io/badge/level-advanced-red.svg)

> In the following tutorial, we're going to build a Firebase Login Flow in Flutter using the Bloc library.

![demo](./assets/gifs/flutter_firebase_login.gif)

## Key Topics

- [BlocProvider](/flutterbloccoreconcepts?id=blocprovider), a Flutter widget which provides a bloc to its children.
- [BlocBuilder](/flutterbloccoreconcepts?id=blocbuilder), a Flutter widget that handles building the widget in response to new states.
- Using Cubit and Bloc. [What's the difference?](/coreconcepts?id=cubit-vs-bloc)
- Adding events with [context.read](/migration?id=❗contextbloc-and-contextrepository-are-deprecated-in-favor-of-contextread-and-contextwatch).⚡
- Prevent unnecessary rebuilds with [Equatable](/faqs?id=when-to-use-equatable).
- [RepositoryProvider](/flutterbloccoreconcepts?id=repositoryprovider), a Flutter widget which provides a repository to its children.
- [BlocListener](/flutterbloccoreconcepts?id=bloclistener), a Flutter widget which invokes the listener code in response to state changes in the bloc.
- Updating the UI based on a part of a bloc state with [context.select](/migration?id=❗contextbloc-and-contextrepository-are-deprecated-in-favor-of-contextread-and-contextwatch).⚡

## Setup

We'll start off by creating a brand new Flutter project.

```sh
flutter create flutter_firebase_login
```

Just like in the [login tutorial](flutterlogintutorial.md), we're going to create internal packages to better layer our application architecture and maintain clear boundaries and to maximize both reusability as well as improve testability.

In this case, the [firebase_auth](https://pub.dev/packages/firebase_auth) and [google_sign_in](https://pub.dev/packages/google_sign_in) packages are going to be our data layer so we're only going to be creating an `AuthenticationRepository` to compose data from the two API clients.

## Authentication Repository

The `AuthenticationRepository` will be responsible for abstracting the internal implementation details of how we authenticate and fetch user information. In this case, it will be integrating with Firebase but we can always change the internal implementation later on and our application will be unaffected.

### Setup

We'll start by creating `packages/authentication_repository` and a `pubspec.yaml` at the root of the project.

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/packages/authentication_repository/pubspec.yaml ':include')

Next, we can install the dependencies by running:

```sh
flutter packages get
```

in the `authentication_repository` directory.

Just like most packages, the `authentication_repository` will define it's API surface via `packages/authentication_repository/lib/authentication_repository.dart`

[authentication_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/packages/authentication_repository/lib/authentication_repository.dart ':include')

?> **Note**: The `authentication_repository` package will be exposing an `AuthenticationRepository` as well as models.

Next, let's take a look at the models.

### User

> The `User` model will describe a user in the context of the authentication domain. For the purposes of this example, a user will consist of an `email`, `id`, `name`, and `photo`.

?> **Note**: It's completely up to you to define what a user needs to look like in the context of your domain.

[user.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/packages/authentication_repository/lib/src/models/user.dart ':include')

?> **Note**: The `User` class is extending [equatable](https://pub.dev/packages/equatable) in order to override equality comparisons so that we can compare different instances of `User` by value.

?> **Tip**: It's useful to define a `static` empty `User` so that we don't have to handle `null` Users and can always work with a concrete `User` object.

### Repository

> The `AuthenticationRepository` is responsible for abstracting the underlying implementation of how a user is authenticated, as well as how a user is fetched.

[authentication_repository.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/packages/authentication_repository/lib/src/authentication_repository.dart ':include')

The `AuthenticationRepository` exposes a `Stream<User>` which we can subscribe to in order to be notified of when a `User` changes. In addition, it exposes methods to `signUp`, `logInWithGoogle`, `logInWithEmailAndPassword`, and `logOut`.

?> **Note**: The `AuthenticationRepository` is also responsible for handling low-level errors that can occur in the data layer and exposes a clean, simple set of errors that align with the domain.

That's it for the `AuthenticationRepository`. Next, let's take a look at how to integrate it into the Flutter project we created.

## Firebase Setup

We need to follow the [firebase_auth usage instructions](https://pub.dev/packages/firebase_auth#usage) in order to hook up our application to Firebase and enable [google_sign_in](https://pub.dev/packages/google_sign_in).

!> Remember to update the `google-services.json` on Android and the `GoogleService-Info.plist` & `Info.plist` on iOS, otherwise the application will crash.

## Project Dependencies

We can replace the generated `pubspec.yaml` at the root of the project with the following:

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/pubspec.yaml ':include')

Notice that we are specifying an assets directory for all of our applications local assets. Create an `assets` directory in the root of your project and add the [bloc logo](https://github.com/felangel/bloc/blob/master/examples/flutter_firebase_login/lib/assets/bloc_logo_small.png) asset (which we'll use later).

Then install all of the dependencies:

```sh
flutter packages get
```

?> **Note**: We are depending on the `authentication_repository` package via path which will allow us to iterate quickly while still maintaining a clear separation.

## main.dart

The `main.dart` file can be replaced with the following:

[main.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/main.dart ':include')

It's simply setting up some global configuration for the application and calling `runApp` with an instance of `App`.

?> **Note**: We're injecting a single instance of `AuthenticationRepository` into the `App` and it is an explicit constructor dependency.

## App

Just like in the [login tutorial](flutterlogintutorial.md), our `app.dart` will provide an instance of the `AuthenticationRepository` to the application via `RepositoryProvider` and also creates and provides an instance of `AuthenticationBloc`. Then `AppView` consumes the `AuthenticationBloc` and handles updating the current route based on the `AuthenticationState`.

[app.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/app/view/app.dart ':include')

## App Bloc

> The `AppBloc` is responsible for managing the global state of the application. It has a dependency on the `AuthenticationRepository` and subscribes to the `user` Stream in order to emit new states in response to changes in the current user.

### State

The `AppState` consists of an `AppStatus` and a `User`. Two named constructors are exposed: `unauthenticated` and `authenticated` to make it easier to work with.

[app_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/app/bloc/app_state.dart ':include')

### Event

The `AppEvent` has two subclasses:

- `AppUserChanged` which notifies the bloc that the current user has changed.
- `AppLogoutRequested` which notifies the bloc that the current user has requested to be logged out.

[app_event.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/app/bloc/app_event.dart ':include')

### Bloc

The `AppBloc` responds to incoming `AppEvents` and transforms them into outgoing `AppStates`. Upon initialization, it immediately subscribes to the `user` stream from the `AuthenticationRepository` and adds an `AuthenticationUserChanged` event internally to process changes in the current user.

!> `close` is overridden in order to handle cancelling the internal `StreamSubscription`.

[app_bloc.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/app/bloc/app_bloc.dart ':include')

## Models

An `Email` and `Password` input model are useful for encapsulating the validation logic and will be used in both the `LoginForm` and `SignUpForm` (later in the tutorial).

Both input models are made using the [formz](https://pub.dev/packages/formz) package and allow us to work with a validated object rather than a primitive type like a `String`.

### Email

[email.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/packages/form_inputs/lib/src/email.dart ':include')

### Password

[email.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/packages/form_inputs/lib/src/password.dart ':include')

## Login Page

The `LoginPage` is responsible for creating and providing an instance of `LoginCubit` to the `LoginForm`.

[login_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/login/view/login_page.dart ':include')

?> **Tip**: It's very important to keep the creation of blocs/cubits separate from where they are consumed. This will allow you to easily inject mock instances and test your view in isolation.

## Login Cubit

> The `LoginCubit` is responsible for managing the `LoginState` of the form. It exposes APIs to `logInWithCredentials`, `logInWithGoogle`, as well as gets notified when the email/password are updated.

### State

The `LoginState` consists of an `Email`, `Password`, and `FormzStatus`. The `Email` and `Password` models extend `FormzInput` from the [formz](https://pub.dev/packages/formz) package.

[login_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/login/cubit/login_state.dart ':include')

### Cubit

The `LoginCubit` has a dependency on the `AuthenticationRepository` in order to sign the user in either via credentials or via google sign in.

[login_cubit.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/login/cubit/login_cubit.dart ':include')

?> **Note**: We used a `Cubit` instead of a `Bloc` here because the `LoginState` is fairly simple and localized. Even without events, we can still have a fairly good sense of what happened just by looking at the changes from one state to another and our code is a lot simpler and more concise.

## Login Form

The `LoginForm` is responsible for rendering the form in response to the `LoginState` and invokes methods on the `LoginCubit` in response to user interactions.

[login_form.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/login/view/login_form.dart ':include')

The `LoginForm` also renders a "Create Account" button which navigates to the `SignUpPage` where a user can create a brand new account.

## Sign Up Page

> The `SignUp` structure mirrors the `Login` structure and consists of a `SignUpPage`, `SignUpView`, and `SignUpCubit`.

The `SignUpPage` is just responsible for creating and providing an instance of the `SignUpCubit` to the `SignUpForm` (exactly like in `LoginPage`).

[sign_up_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/sign_up/view/sign_up_page.dart ':include')

?> **Note**: Just as in the `LoginCubit`, the `SignUpCubit` has a dependency on the `AuthenticationRepository` in order to create new user accounts.

## Sign Up Cubit

The `SignUpCubit` manages the state of the `SignUpForm` and communicates with the `AuthenticationRepository` in order to create new user accounts.

### State

The `SignUpState` reuses the same `Email` and `Password` form input models because the validation logic is the same.

[sign_up_state.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/sign_up/cubit/sign_up_state.dart ':include')

### Cubit

The `SignUpCubit` is extremely similar to the `LoginCubit` with the main exception being it exposes an API to submit the form as opposed to login.

[sign_up_cubit.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/sign_up/cubit/sign_up_cubit.dart ':include')

## Sign Up Form

The `SignUpForm` is responsible for rendering the form in response to the `SignUpState` and invokes methods on the `SignUpCubit` in response to user interactions.

[sign_up_form.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/sign_up/view/sign_up_form.dart ':include')

## Home Page

After a user either successfully logs in or signs up, the `user` stream will be updated which will trigger a state change in the `AuthenticationBloc` and will result in the `AppView` pushing the `HomePage` route onto the navigation stack.

From the `HomePage`, the user can view their profile information and log out by tapping the exit icon in the `AppBar`.

[home_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_firebase_login/lib/home/view/home_page.dart ':include')

?> **Note**: A `widgets` directory was created alongside the `view` directory within the `home` feature for reusable components that are specific to that particular feature. In this case a simple `Avatar` widget is exported and used within the `HomePage`.

?> **Note**: When the logout `IconButton` is tapped, an `AuthenticationLogoutRequested` event is added to the `AuthenticationBloc` which signs the user out and navigates them back to the `LoginPage`.

At this point we have a pretty solid login implementation using Firebase and we have decoupled our presentation layer from the business logic layer by using the Bloc Library.

The full source for this example can be found [here](https://github.com/felangel/bloc/tree/master/examples/flutter_firebase_login).

# Flutter Counter Tutorial

![beginner](https://img.shields.io/badge/level-beginner-green.svg)

> In the following tutorial, we're going to build a Counter in Flutter using the Bloc library.

![demo](./assets/gifs/flutter_counter.gif)

## Key Topics

- Observe state changes with [BlocObserver](/coreconcepts?id=blocobserver).
- [BlocProvider](/flutterbloccoreconcepts?id=blocprovider), Flutter widget which provides a bloc to its children.
- [BlocBuilder](/flutterbloccoreconcepts?id=blocbuilder), Flutter widget that handles building the widget in response to new states.
- Using Cubit instead of Bloc. [What's the difference?](/coreconcepts?id=cubit-vs-bloc)
- Adding events with [context.read](/migration?id=❗contextbloc-and-contextrepository-are-deprecated-in-favor-of-contextread-and-contextwatch).⚡

## Setup

We'll start off by creating a brand new Flutter project

```sh
flutter create flutter_counter
```

We can then go ahead and replace the contents of `pubspec.yaml` with

[pubspec.yaml](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/pubspec.yaml ':include')

and then install all of our dependencies

```sh
flutter packages get
```

## Project Structure

```
├── lib
│   ├── app.dart
│   ├── counter
│   │   ├── counter.dart
│   │   ├── cubit
│   │   │   └── counter_cubit.dart
│   │   └── view
│   │       ├── counter_page.dart
│   │       ├── counter_view.dart
│   │       └── view.dart
│   ├── counter_observer.dart
│   └── main.dart
├── pubspec.lock
├── pubspec.yaml
```

The application uses a feature-driven directory structure. This project structure enables us to scale the project by having self-contained features. In this example we will only have a single feature (the counter itself) but in more complex applications we can have hundreds of different features.

## BlocObserver

The first thing we're going to take a look at is how to create a `BlocObserver` which will help us observe all state changes in the application.

Let's create `lib/counter_observer.dart`:

[counter_observer.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/counter_observer.dart ':include')

In this case, we're only overriding `onChange` to see all state changes that occur.

?> **Note**: `onChange` works the same way for both `Bloc` and `Cubit` instances.

## main.dart

Next, let's replace the contents of `main.dart` with:

[main.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/main.dart ':include')

We're initializing the `CounterObserver` we just created and calling `runApp` with the `CounterApp` widget which we'll look at next.

## Counter App

Let's create `lib/app.dart`:

`CounterApp` will be a `MaterialApp` and is specifying the `home` as `CounterPage`.

[app.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/app.dart ':include')

?> **Note**: We are extending `MaterialApp` because `CounterApp` _is_ a `MaterialApp`. In most cases, we're going to be creating `StatelessWidget` or `StatefulWidget` instances and composing widgets in `build` but in this case there are no widgets to compose so it's simpler to just extend `MaterialApp`.

Let's take a look at `CounterPage` next!

## Counter Page

Let's create `lib/counter/view/counter_page.dart`:

The `CounterPage` widget is responsible for creating a `CounterCubit` (which we will look at next) and providing it to the `CounterView`.

[counter_page.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/counter/view/counter_page.dart ':include')

?> **Note**: It's important to separate or decouple the creation of a `Cubit` from the consumption of a `Cubit` in order to have code that is much more testable and reusable.

## Counter Cubit

Let's create `lib/counter/cubit/counter_cubit.dart`:

The `CounterCubit` class will expose two methods:

- `increment`: adds 1 to the current state
- `decrement`: subtracts 1 from the current state

The type of state the `CounterCubit` is managing is just an `int` and the initial state is `0`.

[counter_cubit.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/counter/cubit/counter_cubit.dart ':include')

?> **Tip**: Use the [VSCode Extension](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc) or [IntelliJ Plugin](https://plugins.jetbrains.com/plugin/12129-bloc) to create new cubits automatically.

Next, let's take a look at the `CounterView` which will be responsible for consuming the state and interacting with the `CounterCubit`.

## Counter View

Let's create `lib/counter/view/counter_view.dart`:

The `CounterView` is responsible for rendering the current count and rendering two FloatingActionButtons to increment/decrement the counter.

[counter_view.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/counter/view/counter_view.dart ':include')

A `BlocBuilder` is used to wrap the `Text` widget in order to update the text any time the `CounterCubit` state changes. In addition, `context.read<CounterCubit>()` is used to look-up the closest `CounterCubit` instance.

?> **Note**: Only the `Text` widget is wrapped in a `BlocBuilder` because that is the only widget that needs to be rebuilt in response to state changes in the `CounterCubit`. Avoid unnecessarily wrapping widgets that don't need to be rebuilt when a state changes.

## Barrel

Create `lib/counter/view/view.dart`:

Add `view.dart` to export all public facing parts of counter view.

[view.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/counter/view/view.dart ':include')


Let's create `lib/counter/counter.dart`:

Add `counter.dart` to export all the public facing parts of the counter feature.

[counter.dart](https://raw.githubusercontent.com/felangel/bloc/master/examples/flutter_counter/lib/counter/counter.dart ':include')

That's it! We've separated the presentation layer from the business logic layer. The `CounterView` has no idea what happens when a user presses a button; it just notifies the `CounterCubit`. Furthermore, the `CounterCubit` has no idea what is happening with the state (counter value); it's simply emitting new states in response to the methods being called.

We can run our app with `flutter run` and can view it on our device or simulator/emulator.

The full source (including unit and widget tests) for this example can be found [here](https://github.com/felangel/Bloc/tree/master/examples/flutter_counter).

# Core Concepts (package:flutter_bloc)

?> Please make sure to carefully read the following sections before working with [package:flutter_bloc](https://pub.dev/packages/flutter_bloc).

?> **Note**: All widgets exported by the `flutter_bloc` package integrate with both `Cubit` and `Bloc` instances.

## Bloc Widgets

### BlocBuilder

**BlocBuilder** is a Flutter widget which requires a `Bloc` and a `builder` function. `BlocBuilder` handles building the widget in response to new states. `BlocBuilder` is very similar to `StreamBuilder` but has a more simple API to reduce the amount of boilerplate code needed. The `builder` function will potentially be called many times and should be a [pure function](https://en.wikipedia.org/wiki/Pure_function) that returns a widget in response to the state.

See `BlocListener` if you want to "do" anything in response to state changes such as navigation, showing a dialog, etc...

If the `bloc` parameter is omitted, `BlocBuilder` will automatically perform a lookup using `BlocProvider` and the current `BuildContext`.

[bloc_builder.dart](_snippets/flutter_bloc_core_concepts/bloc_builder.dart.md ':include')

Only specify the bloc if you wish to provide a bloc that will be scoped to a single widget and isn't accessible via a parent `BlocProvider` and the current `BuildContext`.

[bloc_builder.dart](_snippets/flutter_bloc_core_concepts/bloc_builder_explicit_bloc.dart.md ':include')

For fine-grained control over when the `builder` function is called an optional `buildWhen` can be provided. `buildWhen` takes the previous bloc state and current bloc state and returns a boolean. If `buildWhen` returns true, `builder` will be called with `state` and the widget will rebuild. If `buildWhen` returns false, `builder` will not be called with `state` and no rebuild will occur.

[bloc_builder.dart](_snippets/flutter_bloc_core_concepts/bloc_builder_condition.dart.md ':include')

### BlocSelector

**BlocSelector** is a Flutter widget which is analogous to `BlocBuilder` but allows developers to filter updates by selecting a new value based on the current bloc state. Unnecessary builds are prevented if the selected value does not change. The selected value must be immutable in order for `BlocSelector` to accurately determine whether `builder` should be called again.

If the `bloc` parameter is omitted, `BlocSelector` will automatically perform a lookup using `BlocProvider` and the current `BuildContext`.

[bloc_selector.dart](_snippets/flutter_bloc_core_concepts/bloc_selector.dart.md ':include')

### BlocProvider

**BlocProvider** is a Flutter widget which provides a bloc to its children via `BlocProvider.of<T>(context)`. It is used as a dependency injection (DI) widget so that a single instance of a bloc can be provided to multiple widgets within a subtree.

In most cases, `BlocProvider` should be used to create new blocs which will be made available to the rest of the subtree. In this case, since `BlocProvider` is responsible for creating the bloc, it will automatically handle closing the bloc.

[bloc_provider.dart](_snippets/flutter_bloc_core_concepts/bloc_provider.dart.md ':include')

By default, `BlocProvider` will create the bloc lazily, meaning `create` will get executed when the bloc is looked up via `BlocProvider.of<BlocA>(context)`.

To override this behavior and force `create` to be run immediately, `lazy` can be set to `false`.

[bloc_provider.dart](_snippets/flutter_bloc_core_concepts/bloc_provider_lazy.dart.md ':include')

In some cases, `BlocProvider` can be used to provide an existing bloc to a new portion of the widget tree. This will be most commonly used when an existing bloc needs to be made available to a new route. In this case, `BlocProvider` will not automatically close the bloc since it did not create it.

[bloc_provider.dart](_snippets/flutter_bloc_core_concepts/bloc_provider_value.dart.md ':include')

then from either `ChildA`, or `ScreenA` we can retrieve `BlocA` with:

[bloc_provider.dart](_snippets/flutter_bloc_core_concepts/bloc_provider_lookup.dart.md ':include')

### MultiBlocProvider

**MultiBlocProvider** is a Flutter widget that merges multiple `BlocProvider` widgets into one.
`MultiBlocProvider` improves the readability and eliminates the need to nest multiple `BlocProviders`.
By using `MultiBlocProvider` we can go from:

[bloc_provider.dart](_snippets/flutter_bloc_core_concepts/nested_bloc_provider.dart.md ':include')

to:

[multi_bloc_provider.dart](_snippets/flutter_bloc_core_concepts/multi_bloc_provider.dart.md ':include')

### BlocListener

**BlocListener** is a Flutter widget which takes a `BlocWidgetListener` and an optional `Bloc` and invokes the `listener` in response to state changes in the bloc. It should be used for functionality that needs to occur once per state change such as navigation, showing a `SnackBar`, showing a `Dialog`, etc...

`listener` is only called once for each state change (**NOT** including the initial state) unlike `builder` in `BlocBuilder` and is a `void` function.

If the `bloc` parameter is omitted, `BlocListener` will automatically perform a lookup using `BlocProvider` and the current `BuildContext`.

[bloc_listener.dart](_snippets/flutter_bloc_core_concepts/bloc_listener.dart.md ':include')

Only specify the bloc if you wish to provide a bloc that is otherwise not accessible via `BlocProvider` and the current `BuildContext`.

[bloc_listener.dart](_snippets/flutter_bloc_core_concepts/bloc_listener_explicit_bloc.dart.md ':include')

For fine-grained control over when the `listener` function is called an optional `listenWhen` can be provided. `listenWhen` takes the previous bloc state and current bloc state and returns a boolean. If `listenWhen` returns true, `listener` will be called with `state`. If `listenWhen` returns false, `listener` will not be called with `state`.

[bloc_listener.dart](_snippets/flutter_bloc_core_concepts/bloc_listener_condition.dart.md ':include')

### MultiBlocListener

**MultiBlocListener** is a Flutter widget that merges multiple `BlocListener` widgets into one.
`MultiBlocListener` improves the readability and eliminates the need to nest multiple `BlocListeners`.
By using `MultiBlocListener` we can go from:

[bloc_listener.dart](_snippets/flutter_bloc_core_concepts/nested_bloc_listener.dart.md ':include')

to:

[multi_bloc_listener.dart](_snippets/flutter_bloc_core_concepts/multi_bloc_listener.dart.md ':include')

### BlocConsumer

**BlocConsumer** exposes a `builder` and `listener` in order to react to new states. `BlocConsumer` is analogous to a nested `BlocListener` and `BlocBuilder` but reduces the amount of boilerplate needed. `BlocConsumer` should only be used when it is necessary to both rebuild UI and execute other reactions to state changes in the `bloc`. `BlocConsumer` takes a required `BlocWidgetBuilder` and `BlocWidgetListener` and an optional `bloc`, `BlocBuilderCondition`, and `BlocListenerCondition`.

If the `bloc` parameter is omitted, `BlocConsumer` will automatically perform a lookup using
`BlocProvider` and the current `BuildContext`.

[bloc_consumer.dart](_snippets/flutter_bloc_core_concepts/bloc_consumer.dart.md ':include')

An optional `listenWhen` and `buildWhen` can be implemented for more granular control over when `listener` and `builder` are called. The `listenWhen` and `buildWhen` will be invoked on each `bloc` `state` change. They each take the previous `state` and current `state` and must return a `bool` which determines whether or not the `builder` and/or `listener` function will be invoked. The previous `state` will be initialized to the `state` of the `bloc` when the `BlocConsumer` is initialized. `listenWhen` and `buildWhen` are optional and if they aren't implemented, they will default to `true`.

[bloc_consumer.dart](_snippets/flutter_bloc_core_concepts/bloc_consumer_condition.dart.md ':include')

### RepositoryProvider

**RepositoryProvider** is a Flutter widget which provides a repository to its children via `RepositoryProvider.of<T>(context)`. It is used as a dependency injection (DI) widget so that a single instance of a repository can be provided to multiple widgets within a subtree. `BlocProvider` should be used to provide blocs whereas `RepositoryProvider` should only be used for repositories.

[repository_provider.dart](_snippets/flutter_bloc_core_concepts/repository_provider.dart.md ':include')

then from `ChildA` we can retrieve the `Repository` instance with:

[repository_provider.dart](_snippets/flutter_bloc_core_concepts/repository_provider_lookup.dart.md ':include')

### MultiRepositoryProvider

**MultiRepositoryProvider** is a Flutter widget that merges multiple `RepositoryProvider` widgets into one.
`MultiRepositoryProvider` improves the readability and eliminates the need to nest multiple `RepositoryProvider`.
By using `MultiRepositoryProvider` we can go from:

[repository_provider.dart](_snippets/flutter_bloc_core_concepts/nested_repository_provider.dart.md ':include')

to:

[multi_repository_provider.dart](_snippets/flutter_bloc_core_concepts/multi_repository_provider.dart.md ':include')

## Usage

Lets take a look at how to use `BlocProvider` to provide a `CounterBloc` to a `CounterPage` and react to state changes with `BlocBuilder`.


### counter_bloc.dart

[counter_bloc.dart](_snippets/flutter_bloc_core_concepts/counter_bloc.dart.md ':include')

### main.dart

[main.dart](_snippets/flutter_bloc_core_concepts/counter_main.dart.md ':include')

### counter_page.dart

[counter_page.dart](_snippets/flutter_bloc_core_concepts/counter_page.dart.md ':include')

At this point we have successfully separated our presentational layer from our business logic layer. Notice that the `CounterPage` widget knows nothing about what happens when a user taps the buttons. The widget simply tells the `CounterBloc` that the user has pressed either the increment or decrement button.

## RepositoryProvider Usage

We are going to take a look at how to use `RepositoryProvider` within the context of the [`flutter_weather`][flutter_weather_link] example.

### weather_repository.dart

[weather_repository.dart](_snippets/flutter_bloc_core_concepts/weather_repository.dart.md ':include')

Since the app has an explicit dependency on the `WeatherRepository` we inject an instance via constructor. This allows us to inject different instances of `WeatherRepository` based on the build flavor or environment.

### main.dart

[main.dart](_snippets/flutter_bloc_core_concepts/main.dart.md ':include')

Since we only have one repository in our app, we will inject it into our widget tree via `RepositoryProvider.value`. If you have more than one repository, you can use `MultiRepositoryProvider` to provide multiple repository instances to the subtree.

### app.dart

[app.dart](_snippets/flutter_bloc_core_concepts/app.dart.md ':include')

 In most cases, the root app widget will expose one or more repositories to the subtree via `RepositoryProvider`.

### weather_page.dart

[weather_page.dart](_snippets/flutter_bloc_core_concepts/weather_page.dart.md ':include')

Now when instantiating a bloc, we can access the instance of a repository via `context.read` and inject the repository into the bloc via constructor.

[flutter_weather_link]: https://github.com/felangel/bloc/blob/master/examples/flutter_weather

## Extension Methods

> [Extension methods](https://dart.dev/guides/language/extension-methods), introduced in Dart 2.7, are a way to add functionality to existing libraries. In this section, we'll take a look at extension methods included in `package:flutter_bloc` and how they can be used.

`flutter_bloc` has a dependency on [package:provider](https://pub.dev/packages/provider) which simplifies the use of [`InheritedWidget`](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html).

Internally, `package:flutter_bloc` uses `package:provider` to implement: `BlocProvider`, `MultiBlocProvider`, `RepositoryProvider` and `MultiRepositoryProvider` widgets. `package:flutter_bloc` exports the `ReadContext`, `WatchContext` and `SelectContext`, extensions from `package:provider`.

?> Learn more about [package:provider](https://pub.dev/packages/provider).

### context.read

`context.read<T>()` looks up the closest ancestor instance of type `T` and is functionally equivalent to `BlocProvider.of<T>(context)`. `context.read` is most commonly used for retrieving a bloc instance in order to add an event within `onPressed` callbacks.

!> **Note**: `context.read<T>()` does not listen to `T` -- if the provided `Object` of type `T` changes, `context.read` will not trigger a widget rebuild.

#### Usage

✅ **DO** use `context.read` to add events in callbacks.

```dart
onPressed() {
  context.read<CounterBloc>().add(CounterIncrementPressed()),
}
```

❌ **AVOID** using `context.read` to retrieve state within a `build` method.

```dart
@override
Widget build(BuildContext context) {
  final state = context.read<MyBloc>().state;
  return Text('$state');
}
```

The above usage is error prone because the `Text` widget will not be rebuilt if the state of the bloc changes.

!> Use `BlocBuilder` or `context.watch` instead in order to rebuild in response to state changes.

### context.watch

Like `context.read<T>()`, `context.watch<T>()` provides the closest ancestor instance of type `T`, however it also listens to changes on the instance. It is functionally equivalent to `BlocProvider.of<T>(context, listen: true)`.

If the provided `Object` of type `T` changes, `context.watch` will trigger a rebuild.

!> `context.watch` is only accessible within the `build` method of a `StatelessWidget` or `State` class.

#### Usage

✅ **DO** use `BlocBuilder` instead of `context.watch` to explicitly scope rebuilds.

```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          // Whenever the state changes, only the Text is rebuilt.
          return Text(state.value);
        },
      ),
    ),
  );
}
```

Alternatively, use a `Builder` to scope rebuilds.

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          // Whenever the state changes, only the Text is rebuilt.
          final state = context.watch<MyBloc>().state;
          return Text(state.value);
        },
      ),
    ),
  );
}
```

✅ **DO** use `Builder` and `context.watch` as `MultiBlocBuilder`.

```dart
Builder(
  builder: (context) {
    final stateA = context.watch<BlocA>().state;
    final stateB = context.watch<BlocB>().state;
    final stateC = context.watch<BlocC>().state;

    // return a Widget which depends on the state of BlocA, BlocB, and BlocC
  }
);
```

❌ **AVOID** using `context.watch` when the parent widget in the `build` method doesn't depend on the state.

```dart
@override
Widget build(BuildContext context) {
  // Whenever the state changes, the MaterialApp is rebuilt
  // even though it is only used in the Text widget.
  final state = context.watch<MyBloc>().state;
  return MaterialApp(
    home: Scaffold(
      body: Text(state.value),
    ),
  );
}
```

!> Using `context.watch` at the root of the `build` method will result in the entire widget being rebuilt when the bloc state changes.

### context.select

Just like `context.watch<T>()`, `context.select<T, R>(R function(T value))` provides the closest ancestor instance of type `T` and listens to changes on `T`. Unlike `context.watch`, `context.select` allows you listen for changes in a smaller part of a state.

```dart
Widget build(BuildContext context) {
  final name = context.select((ProfileBloc bloc) => bloc.state.name);
  return Text(name);
}
```

The above will only rebuild the widget when the property `name` of the `ProfileBloc`'s state changes.

#### Usage

✅ **DO** use `BlocSelector` instead of `context.select` to explicitly scope rebuilds.

```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: BlocSelector<ProfileBloc, ProfileState, String>(
        selector: (state) => state.name,
        builder: (context, name) {
          // Whenever the state.name changes, only the Text is rebuilt.
          return Text(name);
        },
      ),
    ),
  );
}
```

Alternatively, use a `Builder` to scope rebuilds.

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          // Whenever state.name changes, only the Text is rebuilt.
          final name = context.select((ProfileBloc bloc) => bloc.state.name);
          return Text(name);
        },
      ),
    ),
  );
}
```

❌ **AVOID** using `context.select` when the parent widget in a build method doesn't depend on the state.

```dart
@override
Widget build(BuildContext context) {
  // Whenever the state.value changes, the MaterialApp is rebuilt
  // even though it is only used in the Text widget.
  final name = context.select((ProfileBloc bloc) => bloc.state.name);
  return MaterialApp(
    home: Scaffold(
      body: Text(name),
    ),
  );
}
```

!> Using `context.select` at the root of the `build` method will result in the entire widget being rebuilt when the selection changes.

# Naming Conventions

!> The following naming conventions are simply recommendations and are completely optional. Feel free to use whatever naming conventions you prefer. You may find some of the examples/documentation do not follow the naming conventions mainly for simplicity/conciseness. These conventions are strongly recommended for large projects with multiple developers.

## Event Conventions

> Events should be named in the **past tense** because events are things that have already occurred from the bloc's perspective.

### Anatomy

[event](_snippets/bloc_naming_conventions/event_anatomy.md ':include')

?> Initial load events should follow the convention: `BlocSubject` + `Started`

!> The base event class should be name: `BlocSubject` + `Event`.

#### Examples

✅ **Good**

[events_good](_snippets/bloc_naming_conventions/event_examples_good.md ':include')

❌ **Bad**

[events_bad](_snippets/bloc_naming_conventions/event_examples_bad.md ':include')

## State Conventions

> States should be nouns because a state is just a snapshot at a particular point in time. There are two common ways to represent state: using subclasses or using a single class.

### Anatomy

#### Subclasses

[state](_snippets/bloc_naming_conventions/state_anatomy.md ':include')

?> When representing the state as multiple subclasses `State` should be one of the following: `Initial` | `Success` | `Failure` | `InProgress` and initial states should follow the convention: `BlocSubject` + `Initial`.

#### Single Class

[state](_snippets/bloc_naming_conventions/single_state_anatomy.md ':include')

?> When representing the state as a single base class an enum named `BlocSubject` + `Status` should be used to represent the status of the state: `initial` | `success` | `failure` | `loading`.

!> The base state class should always be named: `BlocSubject` + `State`.

#### Examples

✅ **Good**

##### Subclasses

[states_good](_snippets/bloc_naming_conventions/state_examples_good.md ':include')

##### Single Class

[states_good](_snippets/bloc_naming_conventions/single_state_examples_good.md ':include')

❌ **Bad**

[states_bad](_snippets/bloc_naming_conventions/state_examples_bad.md ':include')

# Architecture

![Bloc Architecture](assets/bloc_architecture_full.png)

Using the bloc library allows us to separate our application into three layers:

- Presentation
- Business Logic
- Data
  - Repository
  - Data Provider

We're going to start at the lowest level layer (farthest from the user interface) and work our way up to the presentation layer.

## Data Layer

> The data layer's responsibility is to retrieve/manipulate data from one or more sources.

The data layer can be split into two parts:

- Repository
- Data Provider

This layer is the lowest level of the application and interacts with databases, network requests, and other asynchronous data sources.

### Data Provider

> The data provider's responsibility is to provide raw data. The data provider should be generic and versatile.

The data provider will usually expose simple APIs to perform [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations.
We might have a `createData`, `readData`, `updateData`, and `deleteData` method as part of our data layer.

[data_provider.dart](_snippets/architecture/data_provider.dart.md ':include')

### Repository

> The repository layer is a wrapper around one or more data providers with which the Bloc Layer communicates.

[repository.dart](_snippets/architecture/repository.dart.md ':include')

As you can see, our repository layer can interact with multiple data providers and perform transformations on the data before handing the result to the business logic Layer.

## Business Logic Layer

> The business logic layer's responsibility is to respond to input from the presentation layer with new states. This layer can depend on one or more repositories to retrieve data needed to build up the application state.

Think of the business logic layer as the bridge between the user interface (presentation layer) and the data layer. The business logic layer is notified of events/actions from the presentation layer and then communicates with repository in order to build a new state for the presentation layer to consume.

[business_logic_component.dart](_snippets/architecture/business_logic_component.dart.md ':include')

### Bloc-to-Bloc Communication

Because blocs expose streams, it may be tempting to make a bloc which listens to another bloc. You should **not** do this. There are better alternatives than resorting to the code below:

[do_not_do_this_at_home.dart](_snippets/architecture/do_not_do_this_at_home.dart.md ':include')

While the code above is error free (and even cleans up after itself), it has a bigger problem: it creates a dependency between two blocs.

Generally, sibling dependencies between two entities in the same architectural layer should be avoided at all costs, as it creates tight-coupling which is hard to maintain. Since blocs reside in the business logic architectural layer, no bloc should know about any other bloc.

![Application Architecture Layers](assets/architecture.png)

A bloc should only receive information through events and from injected repositories (i.e., repositories given to the bloc in its constructor).

If you're in a situation where a bloc needs to respond to another bloc, you have two other options. You can push the problem up a layer (into the presentation layer), or down a layer (into the domain layer).

#### Connecting Blocs through Presentation

You can use a `BlocListener` to listen to one bloc and add an event to another bloc whenever the first bloc changes.

[blocs_presentation.dart.md](_snippets/architecture/blocs_presentation.dart.md ':include')

The code above prevents `SecondBloc` from needing to know about `FirstBloc`, encouraging loose-coupling. The [flutter_weather](flutterweathertutorial.md) application [uses this technique](https://github.com/felangel/bloc/blob/b4c8db938ad71a6b60d4a641ec357905095c3965/examples/flutter_weather/lib/weather/view/weather_page.dart#L38-L42) to change the app's theme based on the weather information that is received.

In some situations, you may not want to couple two blocs in the presentation layer. Instead, it can often make sense for two blocs to share the same source of data and update whenever the data changes.

#### Connecting Blocs through Domain

Two blocs can listen to a stream from a repository and update their states independent of each other whenever the repository data changes. Using reactive repositories to keep state synchronized is common in large-scale enterprise applications.

First, create or use a repository which provides a data `Stream`. For example, the following repository exposes a never-ending stream of the same few app ideas:

[app_ideas_repo.dart.md](_snippets/architecture/app_ideas_repo.dart.md ':include')

The same repository can be injected into each bloc that needs to react to new app ideas. Below is an `AppIdeaRankingBloc` which yields a state out for each incoming app idea from the repository above:

[blocs_domain.dart.md](_snippets/architecture/blocs_domain.dart.md ':include')

For more about using streams with Bloc, see [How to use Bloc with streams and concurrency](https://verygood.ventures/blog/how-to-use-bloc-with-streams-and-concurrency).

## Presentation Layer

> The presentation layer's responsibility is to figure out how to render itself based on one or more bloc states. In addition, it should handle user input and application lifecycle events.

Most applications flows will start with a `AppStart` event which triggers the application to fetch some data to present to the user.

In this scenario, the presentation layer would add an `AppStart` event.

In addition, the presentation layer will have to figure out what to render on the screen based on the state from the bloc layer.

[presentation_component.dart](_snippets/architecture/presentation_component.dart.md ':include')

So far, even though we've had some code snippets, all of this has been fairly high level. In the tutorial section we're going to put all this together as we build several different example apps.
