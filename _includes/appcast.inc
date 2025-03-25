<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>{{ site.github.project_title }}</title>
        {% for release in site.github.releases %}
            {% unless release.draft and page.release_only %}
                {% assign flag = '<!--' %}
                {% if release.body contains flag %}
                    <item>
                        <title>{{ release.name }}</title>
                        <pubDate>{{ release.published_at | date_to_rfc822 }}</pubDate>

                        {% if release.prerelease %}
                        <sparkle:channel>beta</sparkle:channel>
                        {% endif %}

                        {% assign body = release.body | split:flag %}
                        {% assign description = body.first | strip %}
                        <description xml:lang="en"><![CDATA[{{ description | markdownify }}]]></description>

                        {% if body.size > 2 %}
                        {% assign description_zh = body[1] | strip %}
                        <description xml:lang="zh"><![CDATA[{{ description_zh | markdownify }}]]></description>
                        {% endif %}

                        {% assign enclosure = body.last | strip %}
                        {{ enclosure }}
                    </item>
                {% endif %}
            {% endunless %}
        {% endfor %}
    </channel>
</rss>
