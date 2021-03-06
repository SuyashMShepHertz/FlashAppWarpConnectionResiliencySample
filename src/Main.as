import com.shephertz.appwarp.WarpClient;
import com.shephertz.appwarp.listener.ChatRequestListener;
import com.shephertz.appwarp.listener.ConnectionRequestListener;
import com.shephertz.appwarp.listener.LobbyRequestListener;
import com.shephertz.appwarp.listener.NotificationListener;
import com.shephertz.appwarp.messages.Chat;
import com.shephertz.appwarp.messages.LiveLobby;
import com.shephertz.appwarp.messages.Lobby;
import com.shephertz.appwarp.messages.Move;
import com.shephertz.appwarp.messages.Room;
import com.shephertz.appwarp.types.ResultCode;

import flash.text.TextField;
import flash.utils.ByteArray;

var appwarp:WarpClient;
var outputTextField:TextField = new TextField();
var userinputTextField:TextField = new TextField();

var connectbtn:TextField = new TextField();
var disconnectbtn:TextField = new TextField();
var chatBtn:TextField = new TextField();
var recoverBtn:TextField = new TextField();

var NAME_PROMPT:String = "Enter name and click connect..";
var CHAT_PROMPT:String = "Type message..";

var GREY:uint = 0x999999;
var BLACK:uint = 0x000000;
var WHITE:uint = 0xFFFFFF;
var RED:uint = 0xDF0101;

class connectionListener implements ConnectionRequestListener
{
	public function onConnectDone(res:int):void
	{
		//text.text += "\nonConnectDone : " + res;
		if(res == ResultCode.success)
		{
			outputTextField.text += "\nConnected!";
			appwarp.joinLobby();
		}
		else if(res == ResultCode.success_recovered)
		{
			outputTextField.text += "\nConnection Recovered! " + res.toString();
			userinputTextField.textColor = GREY;    
			chatBtn.backgroundColor = BLACK;
			disconnectbtn.backgroundColor = BLACK;
			recoverBtn.backgroundColor = GREY;
		}
		else if(res == ResultCode.connection_error_recoverable)
		{
			outputTextField.text += "\nRecoverable Connection Error! " + res.toString();
			connectbtn.backgroundColor = GREY;
			chatBtn.backgroundColor = GREY;
			disconnectbtn.backgroundColor = GREY;
			recoverBtn.backgroundColor = BLACK;
		}
		else{
			outputTextField.text += "\nConnection Failed! " + res.toString();
			connectbtn.backgroundColor = BLACK;
			chatBtn.backgroundColor = GREY;
			disconnectbtn.backgroundColor = GREY;
		}
	}
	
	public function onDisConnectDone(res:int):void
	{
		outputTextField.text += "\nDisconnected!";
		userinputTextField.text = NAME_PROMPT;
		userinputTextField.textColor = GREY;
		connectbtn.backgroundColor = BLACK;
		chatBtn.backgroundColor = GREY;
		disconnectbtn.backgroundColor = GREY;
	}
	
	public function onInitUDPDone(res:int):void
	{
		
	}
}

class lobbyListener implements LobbyRequestListener
{
	public function onJoinLobbyDone(event:Lobby):void
	{
		outputTextField.text += "\nonJoinLobbyDonee : "+event.result;
		appwarp.subscribeLobby();
	}
	public function onLeaveLobbyDone(event:Lobby):void
	{
		outputTextField.text += "\nonLeaveLobbyDone : "+event.result;
	}
	public function onSubscribeLobbyDone(event:Lobby):void
	{
		outputTextField.text += "\nonSubscribeLobbyDone : "+event.result;
		if(event.result == ResultCode.success){
			outputTextField.text += "\nReady To Chat!";
			userinputTextField.text = CHAT_PROMPT;
			userinputTextField.textColor = GREY;    
			chatBtn.backgroundColor = BLACK;
			disconnectbtn.backgroundColor = BLACK;
		}
		else{
			outputTextField.text += "\nSubscribe Lobby Failed";
		}
	}
	public function onUnsubscribeLobbyDone(event:Lobby):void
	{
		outputTextField.text += "\nonUnsubscribeLobbyDone : "+event.result;
		appwarp.leaveLobby();
	}
	public function onGetLiveLobbyInfoDone(event:LiveLobby):void
	{
		
	}
}

class chatlistner implements ChatRequestListener
{
	public function onSendChatDone(res:int):void
	{
		outputTextField.text += "\nonSendChatDone : "+res;
		if(res != ResultCode.success){}
		else{
			chatBtn.backgroundColor = BLACK;
			userinputTextField.text = CHAT_PROMPT;
			userinputTextField.textColor = GREY;
		}
	}
	
	public function onSendPrivateChatDone(res:int):void
	{
		
	}
}

class notifylistener implements NotificationListener
{
	public function onRoomCreated(event:Room):void
	{
		
	}
	public function onMoveCompleted(moveEvent:Move):void
	{
		
	}
	public function onPrivateChatReceived(sender:String, chat:String):void
	{
		
	}
	public function onRoomDestroyed(event:Room):void
	{
		
	}
	public function onUserLeftRoom(event:Room, user:String):void
	{
		
	}
	public function onUserJoinedRoom(event:Room, user:String):void
	{
			
	}
	public function onUserLeftLobby(event:Lobby, user:String):void
	{
		outputTextField.text += "\nonUserLeftLobby : "+event.name + " : "+user;
	}
	public function onUserJoinedLobby(event:Lobby, user:String):void
	{
		outputTextField.text += "\nonUserJoinedLobby : "+event.name + " : "+user;		
	}
	public function onChatReceived(event:Chat):void
	{
		outputTextField.text += "\n"+ event.sender+ " : " +event.chat;
	}
	
	public function onUpdatePeersReceived(update:ByteArray, isUDP:Boolean):void
	{
		
	}
	public function onUserChangeRoomProperties(room:Room, user:String,properties:Object, lockTable:Object):void
	{
		
	}
	
	public function onUserPaused(locid:String, isLobby:Boolean, username:String):void
	{
		
	}
	
	public function onUserResumed(locid:String, isLobby:Boolean, username:String):void
	{
		
	}
	
	public function onGameStarted(sender:String, roomid:String, nextTurn:String):void
	{
		
	}
	
	public function onGameStopped(sender:String, roomid:String):void
	{
		
	}
	
}

package
{
	import com.shephertz.appwarp.WarpClient;
	import com.shephertz.appwarp.listener.ConnectionRequestListener;
	import com.shephertz.appwarp.types.ConnectionState;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	public class Main extends Sprite
	{
		private function loadIcons():void
		{
			var appWarpIconLoader:Loader = new Loader();
			appWarpIconLoader.load(new URLRequest("http://appwarp.shephertz.com/images/appwarp_logo.png"));
			appWarpIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAppWarpIconLoaded);
			
			var flashIconLoader:Loader = new Loader();
			flashIconLoader.load(new URLRequest("http://png-2.findicons.com/files/icons/1757/isabi/128/flash_player.png"));
			flashIconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFlashIconLoaded);
			
			function onFlashIconLoaded(event:Event):void 
			{
				event.target.removeEventListener(Event.COMPLETE, onFlashIconLoaded);
				var flashIcon:Bitmap = event.target.content;
				flashIcon.x = 0;
				flashIcon.y = 0;
				flashIcon.width = 128;
				flashIcon.height = 128;
				addChild(flashIcon);
			}
			
			function onAppWarpIconLoaded(event:Event):void 
			{
				event.target.removeEventListener(Event.COMPLETE, onAppWarpIconLoaded);
				var appwarpIcon:Bitmap = event.target.content;
				appwarpIcon.x = 128;
				appwarpIcon.y = 0;
				appwarpIcon.width = 197;
				appwarpIcon.height = 77;
				addChild(appwarpIcon);
			}            
		}
		
		public function Main()
		{
			var headerFormat:TextFormat = new TextFormat();
			headerFormat.size = 20;
			headerFormat.bold = true;
			headerFormat.align = TextFormatAlign.LEFT;
			
			var headerLine1:TextField = new TextField();
			headerLine1.defaultTextFormat = headerFormat;
			headerLine1.text = "AppWarp AS3 FLASH";
			addChild(headerLine1);           
			headerLine1.wordWrap = true;
			headerLine1.width = 250;
			headerLine1.height = 30;
			headerLine1.textColor = RED;
			headerLine1.x = 0;
			headerLine1.y = 0;           
			
			
			var headerLine2:TextField = new TextField();
			headerLine2.defaultTextFormat = headerFormat;
			headerLine2.text = "Chat Demo";
			addChild(headerLine2);           
			headerLine2.wordWrap = true;
			headerLine2.width = 200;
			headerLine2.height = 25;
			headerLine2.textColor = BLACK;
			headerLine2.x = 0;
			headerLine2.y = 30;  
			
			
			outputTextField.width = 600;
			outputTextField.height = 900;
			outputTextField.y = 55;
			addChild(outputTextField);
			
			userinputTextField.width = 265;
			userinputTextField.height = 30;
			userinputTextField.x = 220;
			userinputTextField.text = NAME_PROMPT;
			userinputTextField.textColor = GREY;
			userinputTextField.border = true;
			userinputTextField.type = "input";
			userinputTextField.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
			userinputTextField.addEventListener(FocusEvent.FOCUS_OUT, focusHandler);
			addChild(userinputTextField);
			
			connectbtn.y = userinputTextField.height + userinputTextField.y + 5;
			connectbtn.x = 220;
			connectbtn.selectable = false;
			connectbtn.width = 60;
			connectbtn.height = 25;
			connectbtn.background = true;
			connectbtn.backgroundColor = BLACK;
			connectbtn.textColor = WHITE;
			connectbtn.text = "Connect";
			connectbtn.addEventListener(MouseEvent.CLICK,connect_click);
			addChild(connectbtn);            
			
			disconnectbtn.y = userinputTextField.height + userinputTextField.y + 5;
			disconnectbtn.x = 400;
			disconnectbtn.selectable = false;
			disconnectbtn.width = 65;
			disconnectbtn.height = 25;
			disconnectbtn.background = true;
			disconnectbtn.backgroundColor = GREY;
			disconnectbtn.textColor = WHITE;
			disconnectbtn.text = "Disconnect";
			disconnectbtn.addEventListener(MouseEvent.CLICK,disconnect_click);
			addChild(disconnectbtn);
			
			chatBtn.y = userinputTextField.height + userinputTextField.y + 5;
			chatBtn.x = 300;
			chatBtn.selectable = false;
			chatBtn.width = 60;
			chatBtn.height = 25;
			chatBtn.background = true;
			chatBtn.backgroundColor = GREY;
			chatBtn.textColor = WHITE;
			chatBtn.text = "Send Chat";
			chatBtn.addEventListener(MouseEvent.CLICK,sendchat_click);
			addChild(chatBtn);
			
			recoverBtn.y = 2 * userinputTextField.height + userinputTextField.y + 5;
			recoverBtn.x = 400;
			recoverBtn.selectable = false;
			recoverBtn.width = 65;
			recoverBtn.height = 25;
			recoverBtn.background = true;
			recoverBtn.backgroundColor = GREY;
			recoverBtn.textColor = WHITE;
			recoverBtn.text = "Recover";
			recoverBtn.addEventListener(MouseEvent.CLICK,recover_click);
			addChild(recoverBtn);
			
			WarpClient.initialize("Your App Key","Your Secret Key");
			WarpClient.setRecoveryAllowance(30);
			appwarp = WarpClient.getInstance();
			var _conlistner:ConnectionRequestListener = new connectionListener();
			var _lobbylistener:lobbyListener = new lobbyListener();
			var _chatlistener:chatlistner = new chatlistner();
			var _notifylistener:notifylistener = new notifylistener();
			appwarp.setConnectionRequestListener(_conlistner);
			appwarp.setLobbyRequestListener(_lobbylistener);
			appwarp.setChatRequestListener(_chatlistener);
			appwarp.setNotificationListener(_notifylistener);
		}
		
		// the Listen function
		private  function focusHandler(event:FocusEvent):void
		{
			switch (event.type) {
				case FocusEvent.FOCUS_IN:
					if (userinputTextField.text == NAME_PROMPT || userinputTextField.text == CHAT_PROMPT) {
						userinputTextField.text = "";
						userinputTextField.textColor = BLACK;
					}
					break;
				case FocusEvent.FOCUS_OUT:
					if (userinputTextField.text == "") {
						if(appwarp.getConnectionState() == ConnectionState.disconnected){
							userinputTextField.text = NAME_PROMPT;
						}
						else{
							userinputTextField.text = CHAT_PROMPT;
						}
						userinputTextField.textColor = GREY;
					}
					break;
			}
		}
		
		private function sendchat_click(e:MouseEvent):void
		{
			if(appwarp.getConnectionState() == ConnectionState.connected){
				if(userinputTextField.text != CHAT_PROMPT){
					appwarp.sendChat(userinputTextField.text);                    
					chatBtn.backgroundColor = GREY;
				}
			}
		}
		
		private function connect_click(e:MouseEvent):void
		{
			if(appwarp.getConnectionState() == ConnectionState.disconnected){
				if(userinputTextField.text != NAME_PROMPT){
					outputTextField.text += "\nConnecting...";
					appwarp.connect(userinputTextField.text);
					connectbtn.backgroundColor = GREY;
				}
			}
		}
		
		private function disconnect_click(e:MouseEvent):void
		{
			if(appwarp.getConnectionState() == ConnectionState.connected){
				appwarp.disconnect();
			}
		}
		
		private function recover_click(e:MouseEvent):void
		{
			appwarp.recoverConnection();
		}
	}
}