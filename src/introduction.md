## Introduction to Vue.js {#introduction}

Vue (pronounced /vjuː/, like view) is a progressive framework for building user interfaces. 

Unlike other monolithic frameworks, Vue is designed from the ground up to be incrementally adoptable. 

The core library is focused on the view layer only, and is easy to pick up and integrate with other libraries or existing projects. 

On the other hand, Vue is also perfectly capable of powering sophisticated Single-Page Applications when used in combination with modern tooling and supporting libraries.

### Simple example

At the core of Vue.js is a system that enables us to declaratively render data to the DOM using straightforward template syntax:


```html
<!-- development version, includes helpful console warnings -->
<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>


<h2>
  <div id="app">
    {{ message }}
  </div>
</h2>

<script>
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!'
    }
  })
</script>
```

<!-- development version, includes helpful console warnings -->
<script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>


<h2 class="execution">
  <div id="app">
    {{ message }}
  </div>
</h2>

<script>
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!'
    }
  })
</script>

We have already created our very first Vue app! 

This looks pretty similar to rendering a string template, but Vue has
done a lot of work under the hood. <strong>The data and the DOM are now linked</strong>, 
and everything is now <strong>reactive</strong>!.

#### Check in the developer's tools

<p>
  How do we know?
<ul>
  <li>Open your browser’s JavaScript console (right now, 
  <a href="https://crguezl.github.io/learning-vue-geting-started-guide/" target="_blank">on the GH page</a>) and </li>
  <li> set <code>app.message</code> to a
    different value. </li>
</ul>

You should see the rendered example above update accordingly.
</p>

### Exercise: Install Google Chrome extension for Vue

Install Google Chrome extension for Vue

[![](assets/images/vue-chrome-extension.png)](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd)

Remember to config the extension to allow  `file://` access

### No interpolation occurs outside the Vue app entry point

This message appears verbatim:

```html
<h3>{{ message }}</h3>
```

because it is outside the element to wich Vue has been anchored.

<h3 class="execution">
{{ message }}
</h3>

### The v-bind directive {#v-bind-directive}

Here we define a second entry point for a second Vue app object:

```html
<div id="app-2">
  <span v-bind:title="message">
    <strong>
      Hover your mouse over me for a few seconds
      to see my dynamically bound title!
    </strong>
  </span>
</div>


<script>
  var app2 = new Vue({
    el: '#app-2',
    data: {
      message: 'You loaded this page on ' + new Date().toLocaleString()
    }
  })
</script>
```

<div id="app-2" class="execution">
  <span v-bind:title="message">
    <strong>
      Hover your mouse over me for a few seconds
      to see my dynamically bound title!
    </strong>
  </span>
</div>

<script>
  var app2 = new Vue({
    el: '#app-2',
    data: {
      message: 'You loaded this page on ' + new Date().toLocaleString()
    }
  })
</script>

Here we are encountering something new. 
  
1. The <code>v-bind</code> attribute you are seeing is called a
  <strong>directive</strong>. 
2. Directives are prefixed with <code>v-</code> to indicate that they are special attributes
  provided by Vue, and as you may have guessed, they apply special reactive behavior to the rendered DOM. 
3. Here, it is basically saying **keep this element’s <code>title</code> attribute** 
   up-to-date with the <code>message</code> property on the Vue instance.

If you open up your JavaScript console again and enter 

<code>app2.message = 'some new message'</code>, 

you’ll once again see that the bound HTML - in this case the <code>title</code> attribute - has been updated.


### Conditionals 

It’s easy to toggle the presence of an element, too:

```html
<div id="app-3">
  <span v-if="seen">Now you see me</span>
</div>

<script>
var app3 = new Vue({
  el: '#app-3',
  data: {
    seen: true
  }
})
</script>
```

::: tip
**About this notes**: This example initially didn't work due to `pandoc` modifying the directive `v-if` inside the source to `data-v-if`. I had to remove the `data-` prefix to make it work. The same happens with some other directives.
:::


<div id="app-3" class="execution">
  <span v-if="seen">Now you see me</span>
</div>

<script>
var app3 = new Vue({
  el: '#app-3',
  data: {
    seen: true
  }
})
</script>



### Loops: v-for

There are quite a few other directives, each with its own special functionality. 

For example, the <code>v-for</code> directive can be used for displaying a list of items using the data from an Array:

```html
<div id="app-4">
  <ol>
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>

<script>
var app4 = new Vue({
  el: '#app-4',
  data: {
    todos: [
      { text: 'Learn JavaScript' },
      { text: 'Learn Vue' },
      { text: 'Build something awesome' }
    ]
  }
})
</script>
```

<div id="app-4">
  <ol>
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>

<script>
var app4 = new Vue({
  el: '#app-4',
  data: {
    todos: [
      { text: 'Learn JavaScript' },
      { text: 'Learn Vue' },
      { text: 'Build something awesome' }
    ]
  }
})
</script>


### Handling User Input


```html
<div id="app-5">
  <p>{{ message }}</p>
  <button v-on:click="reverseMessage">Reverse Message</button>
</div>

<script>
var app5 = new Vue({
  el: '#app-5',
  data: {
    message: 'Hello Vue.js!'
  },
  methods: {
    reverseMessage: function () {
      this.message = this.message.split('').reverse().join('')
    }
  }
})
</script>
```

<div id="app-5">
  <p>{{ message }}</p>
  <button v-on:click="reverseMessage">Reverse Message</button>
</div>

<script>
var app5 = new Vue({
  el: '#app-5',
  data: {
    message: 'Hello Vue.js!'
  },
  methods: {
    reverseMessage: function () {
      this.message = this.message.split('').reverse().join('')
    }
  }
})
</script>


### v-model


Vue also provides the v-model directive that makes **two-way binding** between 
**form input** and **app state** a breeze:

```html
<div id="app-6">
  <p>{{ message }}</p>
  <input v-model="message">
</div>

<script>
var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
</script>
```

<div id="app-6" class="execution">
  <p>{{ message }}</p>
  <input v-model="message">
</div>

<script>
var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
</script>

### Composing with Components

The component system is another important concept in Vue, 
because it’s an abstraction that allows us to build large-scale applications composed of small, self-contained, and often reusable components. 

If we think about it, almost any type of application interface can be abstracted into a tree of components:

![](assets/images/components.png)


In Vue, a component is essentially a Vue instance with pre-defined options. Registering a component in Vue is straightforward:

```js
// Define a new component called todo-item
Vue.component('todo-item', {
  template: '<li>This is a todo</li>'
})

var appXXX = new Vue({
  el: '#app-XXX',
  data: {
    groceryList: [
      { id: 0, text: 'Vegetables' },
      { id: 1, text: 'Cheese' },
      { id: 2, text: 'Whatever else humans are supposed to eat' }
    ]
  }
})

```

Now you can compose it in another component’s template:

```html
<div id="app-XXX">
  <ol>
    <todo-item
      v-for="item in groceryList"
    ></todo-item>
  </ol>
</div>
```

But this would render the same text for every todo, which is not super interesting: 

<div id="app-XXX" class="execution">
  <ol>
    <todo-item
      v-for="item in groceryList"
    ></todo-item>
  </ol>
</div>


<script>
// Define a new component called todo-item
Vue.component('todo-item', {
  template: '<li>This is a todo</li>'
})

var appXXX = new Vue({
  el: '#app-XXX',
  data: {
    groceryList: [
      { id: 0, text: 'Vegetables' },
      { id: 1, text: 'Cheese' },
      { id: 2, text: 'Whatever else humans are supposed to eat' }
    ]
  }
})
</script>


*We should be able to pass data from the parent scope into child components.*

Let’s modify the component definition to make it accept a **[prop]**:

[prop]: https://vuejs.org/v2/guide/components.html#Passing-Data-to-Child-Components-with-Props

```js 
Vue.component('todo-item', {
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})
```

The `todo-item` component now accepts a
"[prop]", which is like a *custom attribute*.
This [prop] is called `todo`.

Now we can pass the `todo` into each repeated component using [v-bind](#v-bind-directive):

```html
<div id="app-7">
  <ol>
    <todo-item
      v-for="item in groceryList"
      v-bind:todo="item"
      v-bind:key="item.id"
    ></todo-item>
  </ol>
</div>
```

Now when using the  `todo-item`  we bind the `todo` property  to the 
`item`  in the `groceryList` array so that its content can be dynamic.

We also need to provide each component with a "`key`",
which will be explained later.

```js 
Vue.component('todo-item', {
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})

var app7 = new Vue({
  el: '#app-7',
  data: {
    groceryList: [
      { id: 0, text: 'Vegetables' },
      { id: 1, text: 'Cheese' },
      { id: 2, text: 'Whatever else humans are supposed to eat' }
    ]
  }
})
```
<div id="app-7" class="execution">
  <ol>
    <todo-item
      v-for="item in groceryList"
      v-bind:todo="item"
      v-bind:key="item.id"
    ></todo-item>
  </ol>
</div>

<script>
Vue.component('todo-item', {
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})

var app7 = new Vue({
  el: '#app-7',
  data: {
    groceryList: [
      { id: 0, text: 'Vegetables' },
      { id: 1, text: 'Cheese' },
      { id: 2, text: 'Whatever else humans are supposed to eat' }
    ]
  }
})
</script>

Open the console and add to `app7.groceryList` a new item. See what happens.

See section [Components Basics] to know more about Vue Components.

[Components Basics]: https://vuejs.org/v2/guide/components.html

In a large application, it is necessary to divide the whole app into components to make development manageable. 

We will talk more about components later, but here’s an (imaginary) example of what an app’s template might look like with components:

```html
<div id="app">
  <app-nav></app-nav>
  <app-view>
    <app-sidebar></app-sidebar>
    <app-content></app-content>
  </app-view>
</div>
```

