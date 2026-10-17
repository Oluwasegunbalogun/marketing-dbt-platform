
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}
        {{ default_schema }}

    {%- elif custom_schema_name | trim == 'elementary' -%}
        {{ default_schema }}_elementary

    {%- else -%}
        {{ custom_schema_name | trim }}

    {%- endif -%}
{%- endmacro %}
