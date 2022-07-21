const apiHandler = (payload, context, callback) => {
    console.log(JSON.stringify(payload));
    console.log(JSON.stringify(context));
    callback(null, {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Connect handler called'
        })
    }); 
}
    
module.exports = {
    apiHandler,
}
