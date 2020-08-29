// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

window.React = require("react")
window.ReactDOM = require("react-dom")

import App from './AppLayout'

window.Components = {
  App: App,
}

window.mountReactComponent = function(name, id, data) {
  var component, element, target;
  target = document.getElementById(id);
  component = Components[name];
  if (!target && window.console) {
    return console.warn('Could not find element %c#' + id, 'font-family: monospace');
  }
  if (!component && window.console) {
    return console.warn('Could not find component %c' + name, 'font-family: monospace');
  }

  element = React.createElement(component, { data: data });
  ReactDOM.render(element, target, function() {
    document.addEventListener('page:before-unload', function() {
      ReactDOM.unmountComponentAtNode(target);
    });
  });
};
