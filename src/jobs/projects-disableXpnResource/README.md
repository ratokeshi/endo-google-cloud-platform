# endo or meshblu connector job creation: New copied Job folder

[![Dependency status](http://img.shields.io/david/ratokeshi/endo-google-cloud-platform?style=flat)](https://david-dm.org/ratokeshi/endo-google-cloud-platform)
[![devDependency Status](http://img.shields.io/david/dev/ratokeshi/endo-google-cloud-platform.svg?style=flat)](https://david-dm.org/ratokeshi/endo-google-cloud-platform#info=devDependencies)
[![Build Status](http://img.shields.io/travis/ratokeshi/endo-google-cloud-platform.svg?style=flat&branch=master)](https://travis-ci.org/ratokeshi/endo-google-cloud-platform)

[![NPM](https://nodei.co/npm/endo-google-cloud-platform.svg?style=flat)](https://npmjs.org/package/endo-google-cloud-platform)

## Installing

```bash
$ npm install endo-google-cloud-platform
```

### Usage
modify environment.cson to include port example: for port 8080 use:
```javascript
PORT: 8080
```
From root of endo run endo-doctor which will run this at the end or run the following without endo-doctor
```javascript
node command.js
```
### What to change in the Job folder
*  Must stop and start endo / meshblu connector to see changes in Octoblu Flow
*  Folder name - alphabetical listing of folders results in order placed in Octoblu flow interface
*  List of files to change in job
    *  action.coffee - no immediate changes needed to this file
    *  form.cson - list of variables needed from the user.  The four items below are referenced as properties in the message.cson  
       ```javascript
          angular: [
             'data.field1'
             'data.field2'
             'data.field3'
             'data.field4etc'
             ]
       ```
    *  index.coffee - no changes - this points to the other files in the job folder
    *  job.coffee - Change this. This file is where the real work of the job happens.
    *  message.cson - Change this to see the job in the octoblu flow
        *  3rd line "title:" will change the name of the action in the Octoblu object
        *  4th line 'x-group-name': will change the grouping for actions in the Octoblu object
        *  This file requires a list of types
            *  in the properties section, the field1, field2 etc. should be changed to identify the fields in the Octoblu flow.
            *  In the example below, the action name is the title field.  In the Octoblu flow the form fields are labeled field1, field2, field3, and field4etc.  The options under properties is what is listed in the Octoblu interface.
         ```javascript
            title: 'Name of the action as it appears in the Octoblu Flow'
            type: 'object'
            properties:
              data:
                type: 'object'
                properties:
                  field1:
                    type: 'string'
                  field2:
                    type: 'string'
                  field3:
                    type: 'string'
                  field4etc:
                    type: 'string'
                required: [
                  'operation'
                ]
            ```
    *  response.cson
        *  no immediate changes needed to this file
        *  you will add items here configure responses after the job.coffee runs

## Update Notes
2017-09-2039 11:13 - how to modify a copied job



## License

The MIT License (MIT)

Copyright 2017 Octoblu Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
