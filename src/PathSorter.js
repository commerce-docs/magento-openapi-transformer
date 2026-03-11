/* Sorts a javascript object by its keys */

function sortKeys(obj) {
    if (obj === null || obj === undefined) {
        return {};
    }

    var result = {};
    var keys = Object.keys(obj);
    keys.sort();

    keys.forEach(element=>{
        result[element] = obj[element];
    });

    return result;
}

module.exports = {
    sort: sortKeys
}
