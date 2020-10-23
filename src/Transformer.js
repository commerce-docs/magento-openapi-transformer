const Sorter = require('./PathSorter');
const GroupGenerator = require('./TagGroupsGenerator');
const Updater = require('./TagsUpdater');
const SummaryGenerator = require('./SummaryGenerator');
const TagsGenerator = require('./TagsGenerator');

function tagCompare(a,b){
    return a.name.localeCompare(b.name);
}

module.exports = {

    run: (json) => {
        var result = JSON.parse(json);

        result.paths = SummaryGenerator.generate(Updater.update(Sorter.sort(result.paths))); 

        result.tags = TagsGenerator.generate(result.paths).sort(tagCompare);

        result['x-tagGroups'] = GroupGenerator.generate(result.paths);

        return JSON.stringify(result);
    }
}
