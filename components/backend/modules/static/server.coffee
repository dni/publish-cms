fs = require "fs-extra"
auth = require './../../utilities/auth'

module.exports.setup = (app, config)->

  StaticblockSchema = require('./../../lib/model/Schema')(config.dbTable)

  # Insert Frontend Layout Data
  # StaticblockSchema.count {}, (err, count)->
  #   if count is 0
  #     spawn = require('child_process').spawn
  #     mongoimport = spawn 'mongoimport', ['--db', 'publish', '--collection', 'staticblocks', '--file', 'staticblocks.json'], cwd:__dirname+'/data/'

  # get single static block data frontend
  app.get '/StaticBlock/:id', auth, (req, res)->
    Staticblock.findOne key:req.params.id, (e, a)-> res.send a.data

  # export StaticBlock
  app.get '/exportStaticBlocks', auth, (req, res)->
    if fs.existsSync __dirname+'/data/staticblocks.json' then fs.unlinkSync __dirname+'/data/staticblocks.json'
    spawn = require('child_process').spawn
    mongoexport = spawn('mongoexport', ['-d', 'publish', '-c', 'staticblocks', '-o', 'staticblocks.json'], cwd:__dirname+'/data/').on 'exit', (code)->
      if code is 0
        res.send("Exported Static Blocks")
        console.log("Exported Static Blocks")
      else
        res.send('Error: while exporting Static Blocks, code: ' + code)
        console.log('Error: while exporting Static Blocks, code: ' + code)
