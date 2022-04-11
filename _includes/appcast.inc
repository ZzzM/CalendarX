<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>{{ site.github.project_title }}</title>
        <description>Most recent changes with links to updates.</description>
        <language>en</language>
        {% for release in site.github.releases %}
            {% unless release.draft %}
                {% unless release.prerelease and page.release_only %}
                    {% if release.body contains '<!--' %}
                    <item>
                        <title>{{ release.name }}</title>
                        <description><![CDATA[{{ release.body | markdownify }}]]></description>
                        <pubDate>{{ release.published_at | date_to_rfc822 }}</pubDate>
                        {% for asset in release.assets limit:1 %}
                            {% assign arguments =  release.body | split:'<!--' | last | remove: '-->' |split:',' %}
                            <enclosure
                                url="{{ asset.browser_download_url }}"
                                sparkle:version="{{ arguments.first | strip }}"
                                sparkle:shortVersionString="{{ release.tag_name }}"
                                sparkle:edSignature="{{ arguments.last | strip }}"
                                length="{{ asset.size }}"
                                type="application/octet-stream" />
                        {% endfor %}
                    </item>
                    {% endif %}
                {% endunless %}
            {% endunless %}
        {% endfor %}
    </channel>
</rss>
