const apiHandler = (payload, context, callback) => {
    console.log(`Function apiHandler called`);
    callback(null, {
        statusCode: 200,
        body: JSON.stringify({
            message: 'You\'re authorized by a self signed JWK!'
        })
    }); 
}
    
module.exports = {
    apiHandler,
}
