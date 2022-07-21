const apiHandler = (payload, context, callback) => {
    console.log(JSON.stringify(payload));
    callback(null, {
        statusCode: 200,
        body: JSON.stringify({
            message: `Default message handler called with groups ${payload.requestContext.authorizer.groups}`
        })
    }); 
}
    
module.exports = {
    apiHandler,
}
