{% for plugin in nvim_plugins %}
Plug '{{ plugin.name }}'{% if plugin.do is defined %}, {'do': '{{ plugin.do }}' }{% endif %}

{% endfor %}
