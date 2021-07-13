var request = require('request');
var fs = require('fs')
var md5 = require('md5');

// specify target dir for rendered diagrams
var plantumlDir = "./plantumlGenerated/";
if (!fs.existsSync(plantumlDir)){
    fs.mkdirSync(plantumlDir);
}

var createSVG = (plantumlScript, fileNameAbsolute) => {
    request.post({
        // set you plantuml server here
        url:  'https://plantuml.talsen.team/svg/',
        body: plantumlScript
      })
      .pipe(fs.createWriteStream(fileNameAbsolute));
}


var resolvePlantuml = (markdown) => 
    markdown.replace(/```plantuml\s*([\s\S]*?)```/igm, function(match, text, offset){
        // match "```plantuml" then any whitespace or linebreak
        // then any characters (including line breaks) and mark it as capture group (parenthesis) -> ([\s\S]*?)
        // then "```"
        // -> the found capturegroup is available in the variable "text". It is the plantuml script.
    
        // using md5 hash of the text as filename
        var fileName = "picture" + md5(text) + ".svg"
        var fileNameAbsolute = plantumlDir + fileName;
        
        console.log(text);
        
        // create rendered SVG if not already exists
        if (!fs.existsSync(fileNameAbsolute)) {
            console.log("Save as: " + fileNameAbsolute);
            createSVG(text, fileNameAbsolute);
        } else {
            console.log("File already exists: " + fileNameAbsolute);
        }

        // return an img tag as replacement for the plantuml-script
        return '![img](./plantumlGenerated/'+fileName+')';
    })


module.exports = (markdown, options) => {
    return new Promise((resolve, reject) => {
        return resolve(resolvePlantuml(markdown));
    });
};