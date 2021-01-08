ZSH_THEME="{{ zsh.ohmyzsh_theme }}"
ZSH="{{ zsh.ohmyzsh_dir }}"

plugins=( \
{% for plugin in zsh.ohmyzsh_plugins -%}
  {{ plugin.name }} \
{% endfor -%}
)

{% for plugin in zsh.ohmyzsh_plugins %}
{% if plugin.settings is defined %}{{ plugin.settings }}{% endif %}
{% endfor %}
