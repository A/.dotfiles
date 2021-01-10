ZSH_THEME="{{ ohmyzsh_theme }}"
ZSH="{{ ohmyzsh_dir }}"

plugins=( \
{% for plugin in ohmyzsh_plugins -%}
  {{ plugin.name }} \
{% endfor -%}
)

{% for plugin in ohmyzsh_plugins %}
{% if plugin.settings is defined %}{{ plugin.settings }}{% endif %}
{% endfor %}
