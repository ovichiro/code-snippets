// Use aggregation to group by program id, showing latest date run.
db.testcollection.aggregate([{
    $group:{
        _id: "$program",
        dateRun: {$max: "$dateRun"}
        }
    }]
)

// Reset aggregation
db.getCollection('_properties').update({ "_id": "_properties.collectionName" }, { "aggrs": [] })

// Find with starting string
db.collectionname.find({ "user.name": /^.*SomeName.*$/ })

