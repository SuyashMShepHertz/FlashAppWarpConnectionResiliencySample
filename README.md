#How to use Connection Resiliency

![Screenshot](https://raw.githubusercontent.com/SuyashMShepHertz/FlashAppWarpConnectionResiliencySample/master/Screenshot/screenshot.png)

To recover connection make sure you have set the recovery allowance by calling the setRecoveryAllowance API.

```as3
    WarpClient.setRecoveryAllowance (60);
```

In the above code snippet, the 60 represents the time allowed to recover the connection. It's in seconds. If you did not recover the connection within the defined time, you will be considered fully disconnected.

When the connection breaks, you will receive the onConnectDone Listener with `ResultCode.connection_error_recoverable` result code if recovery allowance was set. 

To recover the connection simply call the recoverConnection() method. If you called the recover connection API before the time defined in the recovery allowance your connection will be successfully recovered with onConnectDone having `ResultCode.success` result code. If the recover connection request was made too late, your request will fail with onConnectDone having `ResultCode.auth_error` result code.

```as3
    WarpClient.GetInstance().recoverConnection();
```

When recovery allowance is set and your connection breaks all users receive onUserPaused() notification listener. When you successfully recover they will receive onUserResumed() notification listener.

# Running the Sample

You will need to set the API key and Secret Key in Main.as at line no. 356

```as3
	WarpClient.initialize("Your App Key","Your Secret Key");
```
