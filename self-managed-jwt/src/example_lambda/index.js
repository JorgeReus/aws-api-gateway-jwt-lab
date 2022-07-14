const apiHandler = (payload, context, callback) => {
    console.log(`Function apiHandler called`);
    callback(null, {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Hello World'
        })
    }); 
}
    
module.exports = {
    apiHandler,
}
