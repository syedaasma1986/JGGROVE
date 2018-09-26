using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Microsoft.Owin.Cors;
using Owin;

[assembly: OwinStartup(typeof(JG_Prospect.Chat.Hubs.Startup))]
namespace JG_Prospect.Chat.Hubs
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // Any connection or hub wire up and configuration should go here
            app.MapSignalR();
            GlobalHost.Configuration.MaxIncomingWebSocketMessageSize = null;
            //app.Map("/signalr", map =>
            //{
            //    map.UseCors(CorsOptions.AllowAll);
            //    var hubConfiguration = new HubConfiguration { };
            //    map.RunSignalR(hubConfiguration);
            //});
        }
    }
}