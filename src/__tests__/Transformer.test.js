const Transformer = require('../Transformer')

test('Transform JSON',() => {
    const json = {
        "hello": "world",
        "foo": "bar",
        "tags": [
            {"name": "tag1"},
            {"name": "tag6"},
            {"name": "tag2"},
            {"name": "tag4"}
        ],
        "paths": {
            "/V1/path4/c": {
                "post": {
                    "tags": ["path4post"]
                },
                "get": {
                    "tags": ["path4get"]
                }
            },
            "/V1/path2": {
                "delete": {
                    "tags": ["path2"]
                }
            },
            "/V1/path4/d": {
                "post": {
                    "tags": ["path4dpost"]
                }
            },
            "/V1/path3/a": {
                "post": {
                    "tags": ["path3"]
                }
            },
            "/V1/path1/a": {
                "post": {
                    "tags": ["path1"]
                }
            }
        }
    };
    const expected = { 
        "hello": "world", 
        "foo": "bar",
        "tags": [
            {"name": "path1/a"},
            {"name": "path2"},
            {"name": "path3/a"},
            {"name": "path4/c"},
            {"name": "path4/d"}
        ],
        "paths": {
            "/V1/path1/a": {
                "post": {
                    "tags": ["path1/a"],
                    "summary": "path1/a"
                }
            },
            "/V1/path2": {
                "delete": {
                    "tags": ["path2"],
                    "summary": "path2"
                }
            },
            "/V1/path3/a": {
                "post": {
                    "tags": ["path3/a"],
                    "summary": "path3/a"
                }
            },
            "/V1/path4/c": {
                "post": {
                    "tags": ["path4/c"],
                    "summary": "path4/c"
                },
                "get": {
                    "tags": ["path4/c"],
                    "summary": "path4/c"
                }
            },
            "/V1/path4/d": {
                "post": {
                    "tags": ["path4/d"],
                    "summary": "path4/d"
                }
            }
        },
        "x-tagGroups": [
            {
                "name": "path1",
                "tags": ["path1/a"]
            },
            {
                "name": "path2",
                "tags": ["path2"]
            },
            {
                "name": "path3",
                "tags": ["path3/a"]
            },
            {
                "name": "path4",
                "tags": ["path4/c","path4/d"]
            }
        ]
    };

    const received = Transformer.run(JSON.stringify(json));

    expect(received).toBe(JSON.stringify(expected)); 
});
