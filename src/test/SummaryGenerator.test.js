const Generator = require('../SummaryGenerator');

test('Generate summary from tags', ()=> {
    const pathsObject = {
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

    const expected = {
        "/V1/path4/c": {
            "post": {
                "tags": ["path4post"],
                "summary": "path4post"
            },
            "get": {
                "tags": ["path4get"],
                "summary": "path4get"
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
                "tags": ["path3"],
                "summary": "path3"
            }
        },
        "/V1/path1/a": {
            "post": {
                "tags": ["path1"],
                "summary": "path1"
            }
        }
    }

    const result = Generator.generate(pathsObject);

    expect(result).toEqual(expected); 
});
