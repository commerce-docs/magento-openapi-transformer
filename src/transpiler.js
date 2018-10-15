const Sorter = require('./PathSorter');
const GroupGenerator = require('./TagGroupsGenerator');
const Updater = require('./TagsUpdater');
const SummaryGenerator = require('./SummaryGenerator');

function tagCompare(a,b){
    return a.name.localeCompare(b.name);
}

module.exports = {

    run: (config,json) => {
        var result = JSON.parse(json);

        result.paths = SummaryGenerator.generate(Updater.update(Sorter.sort(result.paths))); 

        result.tags = result.tags.sort(tagCompare);

        result['x-tagGroups'] = GroupGenerator.generate(result.paths);

        return JSON.stringify(result);
    }
}
