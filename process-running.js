#!/usr/bin/env node

require('shelljs/global');
require('yargs');

var argv = require('yargs')
    .option('name', {
        alias: 'n',
    })
    .describe('n', 'Name of the process')
    .option('expect', {
        alias: 'e',
        default: true,
        type: 'boolean',
    })
    .describe('e', 'What status to expect')
    .demandOption(['n'])
    .help('h')
    .alias('h', 'help')
    .argv;

var result = false;

var description = "check that the '" + argv.name + "' process is " + ( ! argv.expect ? "NOT " : "") + "running";

exec('ps cax | grep ' + argv.name + ' | awk \'{print $5}\'', {silent:true}, function(status, output) {

    if ( output.trim() == argv.name )  {
        result = true;
    }
    
    var output = {status: (argv.expect == result), result: result, description: description, expect: argv.expect }

    console.log(JSON.stringify(output)) 

});