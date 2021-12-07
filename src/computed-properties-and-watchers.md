## Computed Properties and Watchers

### Computed Properties

In-template expressions are very convenient, but they are meant for simple operations. Putting too much logic in your templates can make them bloated and hard to maintain. For example:

```html
<div id="example">
  {{ message.split('').reverse().join('') }}
</div>
```

At this point, the template is no longer simple and declarative. You have to look at it for a second before realizing that it displays message in reverse. The problem is made worse when you want to include the reversed message in your template more than once.

That’s why for any complex logic, you should use a computed property.

#### Basic Example

```html
<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>

<script>
var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // a computed getter
    reversedMessage: function () {
      // `this` points to the vm instance
      return this.message.split('').reverse().join('')
    }
  }
})
</script>
```

Result:

<div id="example" class="execution">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>

<script>
let vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // a computed getter
    reversedMessage: function () {
      // `this` points to the vm instance
      return this.message.split('').reverse().join('')
    }
  }
})
</script>


Here we have declared a computed property `reversedMessage`. 

The function we provided will be used as the getter function for the property `vm.reversedMessage`:

```js
console.log(vm.reversedMessage) // => 'olleH'
vm.message = 'Goodbye'
console.log(vm.reversedMessage) // => 'eybdooG'
```

You can open the console and play with the example `vm` yourself. The value of `vm.reversedMessage` is always dependent on the value of `vm.message`.

**You can data-bind to computed properties in templates just like a normal property**.

Vue is aware that `vm.reversedMessage` depends on `vm.message`, so it will update any bindings that depend on `vm.reversedMessage` when `vm.message` changes. 

And the best part is that we’ve created this dependency relationship declaratively:

the computed getter function has no side effects, which makes it easier to test and understand.

#### Computed Caching vs Methods

You may have noticed we can achieve the same result by invoking a method in the expression:

```js
<p>Reversed message: "{{ reverseMessage() }}"</p>
// in component
methods: {
  reverseMessage: function () {
    return this.message.split('').reverse().join('')
  }
}
```

Instead of a **computed** property, we can define the same function as a **method**. 
For the end result, the two approaches are indeed exactly the same. 

However, the difference between methods and the computed properties is that the **computed properties are cached based on their reactive dependencies**. 

**A computed property will only re-evaluate when some of its reactive dependencies have changed**. 

This means as long as message has not changed, multiple access to the `reversedMessage` computed property will immediately return the previously computed result without having to run the function again.

This also means the following computed property will never update, because `Date.now()` is not a reactive dependency:

```js
computed: {
  now: function () {
    return Date.now()
  }
}
```

In comparison, **a method invocation will always run the function whenever a re-render happens**.

#### Why do we need caching? 

Imagine we have an expensive computed property `A`, which requires looping through a huge Array and doing a lot of computations. 

Then we may have other computed properties that in turn depend on `A`. 

Without caching, we would be executing `A`’s getter many more times than necessary! In cases where you do not want caching, use a method instead.

#### Computed vs Watched Property

Vue does provide a more generic way to observe and react to data changes on a Vue instance: **watch properties**. 

When you have some data that needs to change based on some other data, it is tempting to overuse watch. However, it is often a better idea to use a computed property rather than an imperative watch callback. Consider this example:

```html
<div id="demo">{{ fullName }}</div>
```
```js
var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  },
  watch: {
    firstName: function (val) {
      this.fullName = val + ' ' + this.lastName
    },
    lastName: function (val) {
      this.fullName = this.firstName + ' ' + val
    }
  }
})
```

The above code is imperative and repetitive. Compare it with a computed property version:

```js
var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar'
  },
  computed: {
    fullName: function () {
      return this.firstName + ' ' + this.lastName
    }
  }
})
```

Much better, isn’t it?

#### Computed Setter

Computed properties are by default getter-only, but you can also provide a setter when you need it:

```js
// ...
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
// ...
```

Now when you run `vm.fullName = 'John Doe'`, the setter will be invoked and `vm.firstName` and `vm.lastName` will be updated accordingly.

### Watchers

While computed properties are more appropriate in most cases, there are times when a custom watcher is necessary. 

That’s why Vue provides a more generic way to react to data changes through the `watch` option. 

This is most useful when you want to perform asynchronous or expensive operations in response to changing data.

For example:

```html
<div id="watch-example">
  <p>
    Ask a yes/no question:
    <input v-model="question">
  </p>
  <p>{{ answer }}</p>
</div>
<!-- Since there is already a rich ecosystem of ajax libraries    -->
<!-- and collections of general-purpose utility methods, Vue core -->
<!-- is able to remain small by not reinventing them. This also   -->
<!-- gives you the freedom to use what you're familiar with.      -->
<script src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.13.1/lodash.min.js"></script>
<script>
var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    // whenever question changes, this function will run
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
  created: function () {
    // _.debounce is a function provided by lodash to limit how
    // often a particularly expensive operation can be run.
    // In this case, we want to limit how often we access
    // yesno.wtf/api, waiting until the user has completely
    // finished typing before making the ajax request. To learn
    // more about the _.debounce function (and its cousin
    // _.throttle), visit: https://lodash.com/docs#debounce
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
  methods: {
    getAnswer: function () {
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. ;-)'
        return
      }
      this.answer = 'Thinking...'
      var vm = this
      axios.get('https://yesno.wtf/api')
        .then(function (response) {
          vm.answer = _.capitalize(response.data.answer)
        })
        .catch(function (error) {
          vm.answer = 'Error! Could not reach the API. ' + error
        })
    }
  }
})
</script>
```

Result:


<div id="watch-example" class="execution">
  <p>
    Ask a yes/no question:
    <input v-model="question">
  </p>
  <p>{{ answer }}</p>
</div>
<!-- Since there is already a rich ecosystem of ajax libraries    -->
<!-- and collections of general-purpose utility methods, Vue core -->
<!-- is able to remain small by not reinventing them. This also   -->
<!-- gives you the freedom to use what you're familiar with.      -->
<script src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.13.1/lodash.min.js"></script>
<script>
var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    // whenever question changes, this function will run
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
  created: function () {
    // _.debounce is a function provided by lodash to limit how
    // often a particularly expensive operation can be run.
    // In this case, we want to limit how often we access
    // yesno.wtf/api, waiting until the user has completely
    // finished typing before making the ajax request. To learn
    // more about the _.debounce function (and its cousin
    // _.throttle), visit: https://lodash.com/docs#debounce
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
  methods: {
    getAnswer: function () {
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. ;-)'
        return
      }
      this.answer = 'Thinking...'
      var vm = this
      axios.get('https://yesno.wtf/api')
        .then(function (response) {
          vm.answer = _.capitalize(response.data.answer)
        })
        .catch(function (error) {
          vm.answer = 'Error! Could not reach the API. ' + error
        })
    }
  }
})
</script>

Remember that `v-model` is a two-way binding for form inputs. 
It combines `v-bind`, which brings a JavaScript value from `.data` into the template, and `v-on:input` to update the JavaScript value. 

The `v-model` directive works with all the basic HTML input types (`text`, `textarea`, `number`, `radio`, `checkbox`, `select`).

In this example this bidirectional behavior of `v-model` constitutes a problem  😢 since each time the user press a key the input changes producing a call to the [watch handler function](https://vuejs.org/v2/api/#watch) associated to changes in `question`.

```js
  watch: {
    // whenever question changes, this function will run
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
  ```

If we instead were calling directly `this.getAnwser()` then there is the risk of  
calling `axios.get('https://yesno.wtf/api')` for each pressed key.
Something has to be done regarding this problem.

This is an example of how to use a lifecycle hook seen in section [Lifecycle Diagram](#lifecycle-diagram). When the Vue instance is created we use the `created` hook to create the `debouncedGetAnswer` method from the `getAnswer` method:

```js
  created: function () {
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
```

The call to the Lodash method [`_.debounce(this.getAnswer, 500)`](https://lodash.com/docs/4.17.15#debounce) 

```js
_.debounce(func, [wait=0], [options={}])
```

creates a debounced function that delays invoking `func` until after `wait` milliseconds have elapsed since the last time the debounced function was invoked.

That alleviates the risk to throttle the network. Furthermore, inside `getAnswer` we check for the presence of a `?` character:

```js
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. ;-)'
        return
      }
```
Doing nothing until the question mark appears.

In this case, using the `watch` option allows us 

1. To perform an asynchronous operation (accessing an API), 
2. With additional effort, to limit how often we perform that operation, and 
3. Set intermediary states until we get a final answer. 

None of that would be possible with a computed property.

The `watch` entry of the Vue instance has to be an object where 

1. **keys** are expressions to watch and 
2. **values** are the corresponding callbacks. 
3. The value can also be a string of a method name, or an Object that contains additional options. 
4. The Vue instance will call [$watch()](https://vuejs.org/v2/api/#vm-watch) for each entry in the object at instantiation.

::: tip
Note that you should not use an arrow function to define a watcher (e.g. `searchQuery: newValue => this.updateAutocomplete(newValue))`. 

The reason is arrow functions bind the parent context, so this will not be the Vue instance as you expect and `this.updateAutocomplete` will be undefined.
:::

In addition to the `watch` option, you can also use the imperative 
[`vm.$watch` API](https://vuejs.org/v2/api/#vm-watch).



