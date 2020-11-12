const Generator = require('../TagsGenerator');

test('Generate tags', ()=>{

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

    };

    const expected = [
        {
            "name": "path4post"
        },
        {
            "name": "path4get"
        },
        {
            "name": "path2"
        },
        {
            "name": "path3"
        },
        {
            "name": "path1"
        } 
    ];

    const result = Generator.generate(pathsObject);

    expect(result).toEqual(expected);
});
