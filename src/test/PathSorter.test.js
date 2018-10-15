const Sorter = require('../PathSorter')

test('Sort keys', ()=>{

    const data = {
        "b": "bat",
        "d": "dog",
        "a": "apple",
        "c": "cat"
    };

    const expected = {
        "a": "apple",
        "b": "bat",
        "c": "cat",
        "d": "dog"
    };

    const result = Sorter.sort(data);

    expect(JSON.stringify(result)).toEqual(JSON.stringify(expected));

});
