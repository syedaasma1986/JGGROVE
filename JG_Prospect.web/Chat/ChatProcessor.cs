using Humanizer;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Hosting;
using JG_Prospect.Common;
using Microsoft.AspNet.SignalR;
using JG_Prospect.Chat.Hubs;

namespace JG_Prospect.Chat
{
    public sealed class ChatProcessor : IRegisteredObject
    {
        private Timer _timer;
        private int IdleUserTimeout = 15; // In minutes
        private readonly IHubContext _chatHub;

        private static readonly object padlock = new object();
        private static ChatProcessor instance = null;

        ChatProcessor()
        {
            _chatHub = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
            StartTimer();
        }

        public static ChatProcessor Instance
        {
            get
            {
                if (instance == null)
                {
                    lock (padlock)
                    {
                        if (instance == null)
                        {
                            instance = new ChatProcessor();
                        }
                    }
                }
                return instance;
            }
        }
        private void StartTimer()
        {
            var delayStartby = 2.Seconds();
            var repeatEvery = IdleUserTimeout.Minutes();

            _timer = new Timer(ChatUserStatusToIdleTimer, null, delayStartby, repeatEvery);
        }

        private void ChatUserStatusToIdleTimer(object state)
        {
            if (SingletonUserChatGroups.Instance.ActiveUsers != null)
            {
                var IdleUsers = SingletonUserChatGroups.Instance.ActiveUsers
                                                       .Where(m => m.LastActivityAt < DateTime.UtcNow.AddMinutes(-IdleUserTimeout))
                                                       .ToList();
                SingletonUserChatGroups.Instance.ActiveUsers
                                                       .Where(m => m.LastActivityAt < DateTime.UtcNow.AddMinutes(-IdleUserTimeout))
                                                       .ToList()
                                                       .ForEach(m => m.Status = (int)ChatUserStatus.Idle);

                ChatMessageActiveUser obj = new ChatMessageActiveUser();
                obj.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers.OrderBy(m => m.Status).ToList();

                _chatHub.Clients.All.SetChatUserStatusToIdleCallback(new ActionOutput<ChatMessageActiveUser>
                {
                    Message = "ChatUserStatusToIdleTimer: " + DateTime.UtcNow.ToString(),
                    Status = ActionStatus.Successfull,
                    Object = obj
                });
            }
        }

        public void Stop(bool immediate)
        {
            _timer.Dispose();

            HostingEnvironment.UnregisterObject(this);
        }
    }
}