const Updater = require('../TagsUpdater');

test('Update tags', ()=> {
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
                "tags": ["path4/c"]
            },
            "get": {
                "tags": ["path4/c"]
            }
        },
        "/V1/path2": {
            "delete": {
                "tags": ["path2"]
            }
        },
        "/V1/path3/a": {
            "post": {
                "tags": ["path3/a"]
            }
        },
        "/V1/path1/a": {
            "post": {
                "tags": ["path1/a"]
            }
        }
    }

    const result = Updater.update(pathsObject);

    expect(result).toEqual(expected);
});

