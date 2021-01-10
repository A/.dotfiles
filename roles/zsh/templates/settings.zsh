ZSH_THEME="{{ zsh_ohmyzsh_theme }}"
ZSH="{{ zsh_ohmyzsh_dir }}"

plugins=( \
{% for plugin in zsh_ohmyzsh_plugins -%}
  {{ plugin.name }} \
{% endfor -%}
)

{% for plugin in zsh_ohmyzsh_plugins %}
{% if plugin.settings is defined %}{{ plugin.settings }}{% endif %}
{% endfor %}
