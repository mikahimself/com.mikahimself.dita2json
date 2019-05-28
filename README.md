# A Very Basic DITA to JSON plugin
The `com.mikahimself.dita2json` plugin is a simple DITA-OT plugin that converts DITA topics to a simple JSON format, retaining the content in basic HTML format like so:

```
[
    {
        "title": "Topic 1",
        "text": "<p>Content goes here.</p>",
        "url": "topic1.htm"
    },
    {
        "title": "Topic 2",
        "text": "<p>Other content goes here.</p>",
        "url": "topic2.htm"
    }
]
```
