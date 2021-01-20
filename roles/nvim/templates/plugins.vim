{% for plugin in nvim_plugins %}
{% if plugin.state != 'absent' %}
Plug '{{ plugin.name }}'{% if plugin.do is defined %}, {'do': '{{ plugin.do }}' }{% endif %}

{% endif %}
{% endfor %}
