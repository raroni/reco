Reco: Ruby port of the Eco template compiler.
=============================================

Eco is a wonderful javascript template system by [Sam Stephenson](http://twitter.com/sstephenson/). For more information about Eco visit [its github page](https://github.com/sstephenson/eco).

Reco let you compile Eco templates into Javascript through Ruby like this:

    javascript = Reco.compile File.read('some_template')

With Rails 3.1 you can serve Eco templates i.e. like this:

    // app/assets/templates.js.erb
    window.templates = {};
    <% for template_name in [:user, :post] do %>
      <% template_path = File.join Rails.root, 'app', 'assets', 'templates', "#{template_name}.eco" %>
      <%= Reco.compile File.read(template_path), identifier: "window.templates.#{template_name}" %>
    <% end %>

Javascript that are run after templates.js.erb will now be able to do this:

    window.templates.user({ name: 'Rasmus' }); // returns the rendered HTML
