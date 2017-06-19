#!/usr/bin/env node

require('shelljs/global');
require('yargs');

var argv = require('yargs')
    .option('name', {
        alias: 'n',
    })
    .describe('n', 'Name of the process')
    .option('inverse', {
        alias: 'i',
        default: true,
        type: 'boolean',
    })
    .describe('i', 'Inverse the check')
    .demandOption(['n'])
    .help('h')
    .alias('h', 'help')
    .argv;

var result = false;

var description = "check that the '" + argv.name + "' process is " + ( ! argv.inverse ? "not " : "") + "running";

exec('ps cax | grep ' + argv.name + ' | awk \'{print $5}\'', {silent:true}, function(status, output) {

    if ( output.trim() == argv.name )  {
        result = true;
    }

    var output = {result: (argv.inverse == result), data: result, description: description }

    console.log(JSON.stringify(output))

});
