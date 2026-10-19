
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}
        {{ default_schema }}

    {%- elif custom_schema_name | trim == 'elementary' -%}
        {%- if target.name == 'prod' -%}
            elementary
        {%- else -%}
            {{ default_schema }}_elementary
        {%- endif -%}

    {%- else -%}
        {{ custom_schema_name | trim }}

    {%- endif -%}
{%- endmacro %}
