using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JG_Prospect.Chat.Hubs
{
    public class BaseHub: Hub
    {
        public override System.Threading.Tasks.Task OnConnected()
        {
            //string username = Context.QueryString["username"].ToString();
            string clientId = Context.ConnectionId;
            ChatBLL.Instance.AddChatUser(JGSession.UserId, clientId);
            string data = clientId;
            string count = "";
            try
            {
                count = GetCount().ToString();
            }
            catch (Exception d)
            {
                count = d.Message;
            }
            Clients.Caller.receiveMessage("ChatHub", data, count);
            return base.OnConnected();
        }

        public override System.Threading.Tasks.Task OnReconnected()
        {
            return base.OnReconnected();
        }

        public override System.Threading.Tasks.Task OnDisconnected(bool stopCalled)
        {
            string count = "";
            string msg = "";

            string clientId = Context.ConnectionId;
            ChatBLL.Instance.DeleteChatUser(clientId);

            try
            {
                count = GetCount().ToString();
            }
            catch (Exception d)
            {
                msg = "DB Error " + d.Message;
            }
            string[] Exceptional = new string[1];
            Exceptional[0] = clientId;
            Clients.AllExcept(Exceptional).receiveMessage("NewConnection", clientId + " leave", count);

            return base.OnDisconnected(stopCalled);
        }

        public int GetCount()
        {
            return ChatBLL.Instance.GetChatUserCount();
        }

        public ActionOutput<ChatUser> GetChatUsers()
        {
            return ChatBLL.Instance.GetChatUsers();
        }
    }
}