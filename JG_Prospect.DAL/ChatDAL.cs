using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JG_Prospect.Common;

namespace JG_Prospect.DAL
{
    public class ChatDAL
    {
        public static ChatDAL m_ChatDAL = new ChatDAL();

        public static ChatDAL Instance
        {
            get { return m_ChatDAL; }
            private set {; }
        }
        public DataSet returndata;

        public void AddChatUser(int UserID, string ConnectionId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("AddChatUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserID);
                    database.AddInParameter(command, "@ConnectionId", DbType.String, ConnectionId);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }
        }

        public ActionOutput<ChatUser> GetChatUsers()
        {
            try
            {
                List<ChatUser> users = new List<ChatUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUsers");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            int userId = Convert.ToInt32(item["UserId"].ToString());
                            string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                            ChatUser user = new ChatUser
                            {
                                UserId = userId,
                                //ConnectionId = item["ConnectionId"].ToString(),
                                GroupOrUsername = item["FirstName"].ToString() + " " + item["LastName"].ToString(),
                                //Email = item["Email"].ToString(),
                                ProfilePic = pic,
                                UserInstallId = item["UserInstallId"].ToString(),
                                OnlineAt = Convert.ToDateTime(item["OnlineAt"].ToString()),
                                OnlineAtFormatted = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString()
                            };
                            foreach (DataRow connectionRow in returndata.Tables[0].Rows)
                            {
                                // Same user can open chat in multiple browsers/tabs at the same time.
                                // Adding all ConnectionIds with chat user
                                if (Convert.ToInt32(connectionRow["UserId"].ToString()) == userId)
                                {
                                    user.ConnectionIds.Add(connectionRow["ConnectionId"].ToString());
                                }
                            }
                            if (!users.Select(m => m.UserId).ToList().Contains(user.UserId))
                                users.Add(user);
                        }
                    }
                    else
                    {
                        // User if Offline
                        var usrs = InstallUserDAL.Instance.GetUsersByIds();
                        if (usrs != null && usrs.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow usr in usrs.Tables[0].Rows)
                            {
                                string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(usr["Picture"].ToString()) ? "default.jpg"
                                               : usr["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                                users.Add(new ChatUser
                                {
                                    UserId = Convert.ToInt32(usr["Id"].ToString()),
                                    GroupOrUsername = usr["FristName"].ToString() + " " + usr["LastName"].ToString(),
                                    //Email = usr["Email"].ToString(),
                                    ProfilePic = pic,
                                    UserInstallId = usr["UserInstallId"].ToString(),
                                    OnlineAt = null,
                                    OnlineAtFormatted = null
                                });
                            }
                        }
                    }
                    return new ActionOutput<ChatUser>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public void ChangeTaskChatTitle(int loggedInUserId, int taskId, int taskMultilevelListId, string title)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("ChangeTaskChatTitle");
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                    database.AddInParameter(command, "@TaskId", DbType.Int32, taskId);
                    database.AddInParameter(command, "@TaskMultilevelListId", DbType.Int32, taskMultilevelListId);
                    database.AddInParameter(command, "@Title", DbType.String, title);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public int CreateTaskChatGroup(int taskId, int? taskMultilevelListId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("CreateTaskChatGroup");
                    database.AddInParameter(command, "@TaskId", DbType.Int32, taskId);
                    database.AddInParameter(command, "@TaskMultilevelListId", DbType.Int32, taskMultilevelListId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return Convert.ToInt32(returndata.Tables[0].Rows[0]["UserChatGroupId"].ToString());
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public int SaveChatFile(string imageName, string newImageName, string contentType)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SaveChatFile");
                    database.AddInParameter(command, "@DisplayName", DbType.String, imageName);
                    database.AddInParameter(command, "@SavedName", DbType.String, newImageName);
                    database.AddInParameter(command, "@Mime", DbType.String, contentType);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return Convert.ToInt32(returndata.Tables[0].Rows[0]["FileId"].ToString());
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public DateTime SaveLastChatSeen(int senderUserId, int userChatGroupId, int receiverId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SaveLastChatSeen");
                    database.AddInParameter(command, "@SenderUserId", DbType.Int32, senderUserId);
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);
                    database.AddInParameter(command, "@ReceiverUserId", DbType.Int32, receiverId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return Convert.ToDateTime(returndata.Tables[0].Rows[0]["ChatSeenAt"].ToString());
                }
            }
            catch (Exception ex)
            {
                return DateTime.Now.AddYears(-100);
            }
        }

        public void AddHRChatMessage(int userId, string message, long? EmailStatusId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("AddHRChatMessage");
                    database.AddInParameter(command, "@Id", DbType.Int32, userId);
                    database.AddInParameter(command, "@Message", DbType.String, message);
                    database.AddInParameter(command, "@EmailStatusId", DbType.Int64, EmailStatusId);

                    command.CommandType = CommandType.StoredProcedure;
                    database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
            }
        }
        public List<int> GetActiveUsersByLoggedInUser(List<int> list, int loggedInUserId)
        {
            List<int> ActiveUsers = new List<int>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetActiveUsersByLoggedInUser");
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                    database.AddInParameter(command, "@ConnectedUsers", DbType.String, string.Join(",", list.Distinct()));

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata.Tables != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            ActiveUsers.Add(Convert.ToInt32(item["UserId"]));
                        }
                    }
                    return ActiveUsers;
                }
            }
            catch (Exception ex)
            {
                return ActiveUsers;
            }
        }

        public DateTime? GetLastChatSeen(int senderUserId, int userChatGroupId, int receiverId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetLastChatSeen");
                    database.AddInParameter(command, "@SenderUserId", DbType.Int32, senderUserId);
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);
                    database.AddInParameter(command, "@ReceiverUserId", DbType.Int32, receiverId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (string.IsNullOrEmpty(returndata.Tables[0].Rows[0]["ChatSeenAt"].ToString()))
                        return null;
                    return Convert.ToDateTime(returndata.Tables[0].Rows[0]["ChatSeenAt"].ToString());
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public int? GetUserChatGroupId(string chatGroupId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetUserChatGroupId");
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, chatGroupId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (string.IsNullOrEmpty(returndata.Tables[0].Rows[0]["UserChatGroupId"].ToString()))
                        return null;
                    return Convert.ToInt32(returndata.Tables[0].Rows[0]["UserChatGroupId"].ToString());
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void RemoveChatGroupMember(int userChatGroupId, int userId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("RemoveChatGroupMember");
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public List<ChatUser> GetChatGroupMembers(int loggedInUserId, int? userChatGroupId)
        {
            List<ChatUser> users = new List<ChatUser>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatGroupMembers");
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in returndata.Tables[0].Rows)
                        {
                            users.Add(new ChatUser
                            {
                                UserId = Convert.ToInt32(dr["Id"].ToString()),
                                GroupOrUsername = dr["FristName"].ToString() + " " + dr["LastName"].ToString(),
                                UserInstallId = dr["UserInstallId"].ToString()
                            });
                        }
                    }
                }
                return users;
            }
            catch (Exception ex)
            {
                return users;
            }
        }

        public List<ChatUser> GetChatGroupMembers(int userChatGroupId)
        {
            List<ChatUser> users = new List<ChatUser>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatGroupMembers");
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in returndata.Tables[0].Rows)
                        {
                            users.Add(new ChatUser
                            {
                                UserId = Convert.ToInt32(dr["Id"].ToString()),
                                GroupOrUsername = dr["FristName"].ToString() + " " + dr["LastName"].ToString(),
                                UserInstallId = dr["UserInstallId"].ToString()
                            });
                        }
                    }
                }
                return users;
            }
            catch (Exception ex)
            {
                return users;
            }
        }

        public UserChatGroup GetChatGroup(int userChatGroupId)
        {
            UserChatGroup grp = new UserChatGroup();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatGroup");
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        DataRow dr = returndata.Tables[0].Rows[0];
                        grp.ChatGroupType = string.IsNullOrEmpty(dr["ChatGroupType"].ToString()) ? null : (int?)Convert.ToInt32(dr["ChatGroupType"].ToString());
                        grp.Id = Convert.ToInt32(dr["Id"].ToString());
                        grp.TaskId = string.IsNullOrEmpty(dr["TaskId"].ToString()) ? null : (long?)Convert.ToInt64(dr["TaskId"].ToString());
                        grp.TaskMultilevelListId = string.IsNullOrEmpty(dr["TaskMultilevelListId"].ToString()) ? null : (int?)Convert.ToInt32(dr["TaskMultilevelListId"].ToString());
                        grp.UserChatGroupTitle = dr["UserChatGroupTitle"].ToString();
                    }
                }
                return grp;
            }
            catch (Exception ex)
            {
                return grp;
            }
        }

        public int AddMemberToChatGroup(string chatGroupId, int userId, int loggedInUserId, string existingUsers, int? userChatGroupId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("AddMemberToChatGroup");
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, chatGroupId);
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                    database.AddInParameter(command, "@ExistingUsers", DbType.String, existingUsers);
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return Convert.ToInt32(returndata.Tables[0].Rows[0]["UserChatGroupId"].ToString());
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public ChatFile GetChatFile(int id)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatFile");
                    database.AddInParameter(command, "@FileId", DbType.Int32, id);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables.Count > 0 && returndata.Tables[0].Rows.Count > 0)
                    {
                        return new ChatFile
                        {
                            Id = Convert.ToInt32(returndata.Tables[0].Rows[0]["Id"].ToString()),
                            DisplayName = returndata.Tables[0].Rows[0]["DisplayName"].ToString(),
                            Mime = returndata.Tables[0].Rows[0]["Mime"].ToString(),
                            SavedName = returndata.Tables[0].Rows[0]["SavedName"].ToString()
                        };
                    }
                    return null;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public bool SetTaskStepStatus(int taskId, int userId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SetTaskStepStatus");
                    database.AddInParameter(command, "@TaskId", DbType.Int32, taskId);
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables.Count > 0 && returndata.Tables[0].Rows.Count > 0)
                    {
                        return Convert.ToBoolean(returndata.Tables[0].Rows[0]["StepCompleted"].ToString());
                    }
                    return false;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public void ChatLogger(string chatGroupId, string message, int chatSourceId, int UserId, string IP)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SaveChatLog");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, chatGroupId);
                    database.AddInParameter(command, "@Message", DbType.String, message);
                    database.AddInParameter(command, "@ChatSourceId", DbType.String, chatSourceId);
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserId);
                    database.AddInParameter(command, "@IP", DbType.String, IP);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }
        }

        public ActionOutput<ChatUser> GetChatUsers(List<int> userIds)
        {
            try
            {
                List<ChatUser> users = new List<ChatUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUsers");
                    database.AddInParameter(command, "@UserIds", DbType.String, string.Join(",", userIds));

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            int userId = Convert.ToInt32(item["UserId"].ToString());
                            string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                            ChatUser user = new ChatUser
                            {
                                UserId = userId,
                                GroupOrUsername = item["FirstName"].ToString() + " " + item["LastName"].ToString(),
                                //Email = item["Email"].ToString(),
                                ProfilePic = pic,
                                UserInstallId = item["UserInstallId"].ToString(),
                                OnlineAt = Convert.ToDateTime(item["OnlineAt"].ToString()),
                                OnlineAtFormatted = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString()
                            };
                            if (!string.IsNullOrEmpty(item["ConnectionId"].ToString()))
                                user.ConnectionIds.AddRange(item["ConnectionId"].ToString().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList());
                            //foreach (DataRow connectionRow in returndata.Tables[0].Rows)
                            //{
                            //    // Same user can open chat in multiple browsers/tabs at the same time.
                            //    // Adding all ConnectionIds with chat user
                            //    if (Convert.ToInt32(connectionRow["UserId"].ToString()) == userId)
                            //    {
                            //        user.ConnectionIds.Add(connectionRow["ConnectionId"].ToString());
                            //    }
                            //}
                            users.Add(user);
                        }
                    }
                    userIds.RemoveAll(m => users.Select(x => x.UserId).ToList().Contains(m));
                    // User if Offline
                    if (userIds.Count() > 0)
                    {
                        var usrs = InstallUserDAL.Instance.GetUsersByIds(userIds);
                        if (usrs != null && usrs.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow usr in usrs.Tables[0].Rows)
                            {
                                string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(usr["Picture"].ToString()) ? "default.jpg"
                                               : usr["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                                users.Add(new ChatUser
                                {
                                    UserId = Convert.ToInt32(usr["Id"].ToString()),
                                    GroupOrUsername = usr["FristName"].ToString() + " " + usr["LastName"].ToString(),
                                    //Email = usr["Email"].ToString(),
                                    ProfilePic = pic,
                                    UserInstallId = usr["UserInstallId"].ToString(),
                                    OnlineAt = null,
                                    OnlineAtFormatted = null
                                });
                            }
                        }
                    }
                }
                return new ActionOutput<ChatUser>
                {
                    Results = users,
                    Status = ActionStatus.Successfull
                };
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<ChatUser> GetChatUser(int UserId)
        {
            try
            {
                ChatUser user = null;
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUser");
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        DataRow item = returndata.Tables[0].Rows[0];
                        string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                        user = new ChatUser
                        {
                            UserId = Convert.ToInt32(item["UserId"].ToString()),
                            //ConnectionId = item["ConnectionId"].ToString(),
                            GroupOrUsername = item["FirstName"].ToString() + " " + item["LastName"].ToString(),
                            //Email = item["Email"].ToString(),
                            ProfilePic = pic,
                            UserInstallId = item["UserInstallId"].ToString(),
                            OnlineAt = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST(),
                            OnlineAtFormatted = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString()
                        };
                        // Same user can open chat in multiple browsers/tabs at the same time.
                        // Adding all ConnectionIds with chat user
                        foreach (DataRow connectionRow in returndata.Tables[0].Rows)
                        {
                            user.ConnectionIds.Add(connectionRow["ConnectionId"].ToString());
                        }
                    }
                    else
                    {
                        // User if Offline
                        var usr = InstallUserDAL.Instance.getuserdetails(UserId).Tables[0].Rows[0];
                        string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(usr["Picture"].ToString()) ? "default.jpg"
                                                : usr["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                        user = new ChatUser
                        {
                            UserId = UserId,
                            GroupOrUsername = usr["FristName"].ToString() + " " + usr["LastName"].ToString(),
                            //Email = usr["Email"].ToString(),
                            ProfilePic = pic,
                            UserInstallId = usr["UserInstallId"].ToString(),
                            OnlineAt = null,
                            OnlineAtFormatted = null
                        };
                    }
                    return new ActionOutput<ChatUser>
                    {
                        Object = user,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Successfull
                };
            }
        }

        public ActionOutput<ChatUser> GetChatUser(string ConnectionId)
        {
            try
            {
                ChatUser user = null;
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUserByConnectionId");
                    database.AddInParameter(command, "@ConnectionId", DbType.String, ConnectionId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        DataRow item = returndata.Tables[0].Rows[0];
                        string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                        user = new ChatUser
                        {
                            UserId = Convert.ToInt32(item["UserId"].ToString()),
                            //ConnectionId = item["ConnectionId"].ToString(),
                            GroupOrUsername = item["FirstName"].ToString() + " " + item["LastName"].ToString(),
                            //Email = item["Email"].ToString(),
                            ProfilePic = pic,
                            UserInstallId = item["UserInstallId"].ToString(),
                            OnlineAt = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST(),
                            OnlineAtFormatted = Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString()
                        };
                        // Same user can open chat in multiple browsers/tabs at the same time.
                        // Adding all ConnectionIds with chat user
                        foreach (DataRow connectionRow in returndata.Tables[0].Rows)
                        {
                            user.ConnectionIds.Add(connectionRow["ConnectionId"].ToString());
                        }
                    }
                    else
                    {
                        // User if Offline
                        user = new ChatUser
                        {
                            OnlineAt = null,
                            OnlineAtFormatted = null
                        };
                    }
                    return new ActionOutput<ChatUser>
                    {
                        Object = user,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Successfull
                };
            }
        }

        public ActionOutput<ActiveUser> GetOnlineUsers(int LoggedInUserId, string sortBy = "recent", string filterBy = "",
                                                            int pageNumber = 1, int pageSize = 20, int? DepartmentId = null,
                                                            string type = "all", bool markAllRead = false,
                                                            int? userStatus = null)
        {
            try
            {
                int totalCalls = 0;
                int totalAutoEntries = 0;
                List<ActiveUser> users = new List<ActiveUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetOnlineUsers");
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, LoggedInUserId);
                    database.AddInParameter(command, "@SortBy", DbType.String, sortBy);
                    database.AddInParameter(command, "@FilterBy", DbType.String, filterBy);
                    database.AddInParameter(command, "@PageNumber", DbType.Int32, pageNumber);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pageSize);
                    database.AddInParameter(command, "@DepartmentId", DbType.Int32, DepartmentId);
                    database.AddInParameter(command, "@Type", DbType.String, type);
                    database.AddInParameter(command, "@MarkAllRead", DbType.Boolean, markAllRead);
                    database.AddInParameter(command, "@UserStatus", DbType.Int32, userStatus);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                    : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                            users.Add(new ActiveUser
                            {
                                UserId = string.IsNullOrEmpty(item["UserId"].ToString()) ? null : (int?)Convert.ToInt32(item["UserId"].ToString()),
                                GroupOrUsername = item["GroupOrUsername"].ToString(),
                                ProfilePic = pic,
                                UserInstallId = item["UserInstallId"].ToString(),
                                OnlineAt = !string.IsNullOrEmpty(item["OnlineAt"].ToString()) ?
                                                    (DateTime?)Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST() : null,
                                OnlineAtFormatted = !string.IsNullOrEmpty(item["OnlineAt"].ToString()) ?
                                                        Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString() : null,
                                LastMessage = item["LastMessage"].ToString(),
                                LastMessageAt = !string.IsNullOrEmpty(item["MessageAt"].ToString()) ?
                                                    (DateTime?)Convert.ToDateTime(item["MessageAt"].ToString()).ToEST() : null,
                                LastMessageAtFormatted = !string.IsNullOrEmpty(item["MessageAt"].ToString()) ?
                                                    Convert.ToDateTime(item["MessageAt"].ToString()).ToEST().ToString() : null,
                                IsRead = Convert.ToBoolean(item["IsRead"].ToString()),
                                ChatGroupId = item["ChatGroupId"].ToString(),
                                ReceiverIds = item["ReceiverIds"].ToString(),
                                InstallUserStatusId = !string.IsNullOrEmpty(item["UserStatus"].ToString())
                                                                ? (int?)Convert.ToInt32(item["UserStatus"].ToString()) : null,
                                Status = (int)ChatUserStatus.Offline,
                                TaskId = string.IsNullOrEmpty(item["TaskId"].ToString()) ? 0 : Convert.ToInt32(item["TaskId"].ToString()),
                                TaskMultilevelListId = string.IsNullOrEmpty(item["TaskMultilevelListId"].ToString()) ? 0 : Convert.ToInt32(item["TaskMultilevelListId"].ToString()),
                                UnreadCount = Convert.ToInt32(item["UnreadCount"].ToString()),
                                GroupNameAnchor = item["GroupNameAnchor"].ToString(),
                                UserChatGroupId = string.IsNullOrEmpty(item["UserChatGroupId"].ToString()) ? 0 : Convert.ToInt32(item["UserChatGroupId"].ToString()),
                                ChatGroupType = string.IsNullOrEmpty(item["ChatGroupType"].ToString()) ? null : (int?)Convert.ToInt32(item["ChatGroupType"].ToString()),
                                ChatGroupMemberImages = item["ChatGroupMemberImages"].ToString(),

                                LastLoginAt = !string.IsNullOrEmpty(item["LastLoginAt"].ToString()) ?
                                                    (DateTime?)Convert.ToDateTime(item["LastLoginAt"].ToString()).ToEST() : null,
                                LastLoginAtFormatted = !string.IsNullOrEmpty(item["LastLoginAt"].ToString()) ?
                                                    Convert.ToDateTime(item["LastLoginAt"].ToString()).ToEST().ToString() : null,
                                DepartmentId = string.IsNullOrEmpty(item["DepartmentId"].ToString()) ? null : (int?)Convert.ToInt32(item["DepartmentId"].ToString()),
                                DepartmentName = item["DepartmentName"].ToString(),
                                TotalAutoEntries = Convert.ToInt32(item["TotalAutoEntries"].ToString())
                            });
                        }
                    }
                    if (returndata != null && returndata.Tables[1] != null && returndata.Tables[1].Rows.Count > 0)
                    {
                        totalCalls = Convert.ToInt32(returndata.Tables[1].Rows[0]["TotalCalls"].ToString());
                    }
                    if (returndata != null && returndata.Tables[2] != null && returndata.Tables[2].Rows.Count > 0)
                    {
                        totalAutoEntries = Convert.ToInt32(returndata.Tables[2].Rows[0]["TotalAutoEntries"].ToString());
                    }
                    return new ActionOutput<ActiveUser>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull,
                        Message = totalCalls.ToString() + ":" + totalAutoEntries
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ActiveUser>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<bool> SetChatMessageRead(string ChatGroupId, int ReceiverId, int UserChatGroupId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SetChatMessageReadByChatGroupId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, ChatGroupId);
                    database.AddInParameter(command, "@ReceiverId", DbType.Int32, ReceiverId);
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, UserChatGroupId);
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        return new ActionOutput<bool>
                        {
                            Status = ActionStatus.Successfull,
                            Object = Convert.ToBoolean(returndata.Tables[0].Rows[0]["IsRead"]),
                            Message = returndata.Tables[0].Rows[0]["WelcomeEmailStatus"].ToString()
                        };
                    }
                    return new ActionOutput<bool> { Status = ActionStatus.Successfull, Object = false };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<bool> { Status = ActionStatus.Successfull, Object = false };
            }
        }

        public int GetChatUserCount()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUserCount");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return Convert.ToInt32(returndata.Tables[0].Rows[0]["TotalCount"].ToString());
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public void DeleteChatUser(string ConnectionId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("DeleteChatUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ConnectionId", DbType.String, ConnectionId);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void SaveChatMessage(ChatMessage message, string ChatGroupId, string ReceiverIds, int SenderUserId, long EmailStatusId = 0)
        {
            try
            {
                // sort ReceiverIds into Asc
                List<int> ids = ReceiverIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                           .Select(m => Convert.ToInt32(m))
                                           .Distinct()
                                           .ToList();

                // Remove SenderId From ReceiverIds
                if (ids.Count() > 0 && ids.Contains(SenderUserId))
                    ids.Remove(SenderUserId);

                // Create CSV values from ids
                ReceiverIds = string.Join(",", ids.OrderBy(m => m).ToList());

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SaveChatMessage");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ChatSourceId", DbType.Int32, message.ChatSourceId);
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, ChatGroupId);
                    database.AddInParameter(command, "@SenderId", DbType.Int32, message.UserId);
                    database.AddInParameter(command, "@TextMessage", DbType.String, message.Message);
                    database.AddInParameter(command, "@ChatFileId", DbType.String, message.FileId);
                    database.AddInParameter(command, "@ReceiverIds", DbType.String, ReceiverIds);
                    database.AddInParameter(command, "@TaskId", DbType.Int32, message.TaskId);
                    database.AddInParameter(command, "@TaskMultilevelListId", DbType.Int32, message.TaskMultilevelListId);
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, message.UserChatGroupId);
                    database.AddInParameter(command, "@IsWelcomeEmail", DbType.Boolean, false);
                    database.AddInParameter(command, "@EmailStatusId", DbType.Int64, EmailStatusId);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public ActionOutput<ChatMessage> GetChatMessages(int LoggedInUserId, string ChatGroupId, string receiverIds, int chatSourceId,
                                                                int userChatGroupId, int pageNumber, int pageSize)
        {
            try
            {
                List<ChatMessage> messages = new List<ChatMessage>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatMessages");
                    database.AddInParameter(command, "@ChatGroupId", DbType.String, ChatGroupId);
                    database.AddInParameter(command, "@ReceiverIds", DbType.String, receiverIds);
                    database.AddInParameter(command, "@ChatSourceId", DbType.Int32, chatSourceId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, LoggedInUserId);
                    database.AddInParameter(command, "@UserChatGroupId", DbType.Int32, userChatGroupId);
                    database.AddInParameter(command, "@PageNumber", DbType.Int32, pageNumber);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pageSize);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            // DataRow item = returndata.Tables[0].Rows[0];
                            string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                    : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                            messages.Add(new ChatMessage
                            {
                                ChatGroupId = item["ChatGroupId"].ToString(),
                                UserId = Convert.ToInt32(item["SenderId"].ToString()),
                                Message = item["TextMessage"].ToString(),
                                FileId = string.IsNullOrEmpty(item["ChatFileId"].ToString()) ? null : (int?)(Convert.ToInt32(item["ChatFileId"].ToString())),
                                ChatSourceId = Convert.ToInt32(item["ChatSourceId"].ToString()),
                                UserProfilePic = pic,
                                UserInstallId = item["UserInstallId"].ToString(),
                                UserFullname = item["Fullname"].ToString(),
                                MessageAt = Convert.ToDateTime(item["CreatedOn"].ToString()),
                                MessageAtFormatted = Convert.ToDateTime(item["CreatedOn"].ToString()).ToString(),
                                IsRead = Convert.ToBoolean(item["IsRead"].ToString()),
                                WelcomeEmailStatus = Convert.ToInt32(item["WelcomeEmailStatus"].ToString()),
                                ReceiverIds = item["ReceiverIds"].ToString()
                            });
                        }
                    }
                    return new ActionOutput<ChatMessage>
                    {
                        Results = messages.OrderBy(m => m.MessageAt).ToList(),
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatMessage>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<ChatMessage> GetChatMessagesByUsers(int userId, int receiverId, int chatSourceId, int pageNumber, int pageSize)
        {
            try
            {
                List<ChatMessage> messages = new List<ChatMessage>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatMessagesByUsers");
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                    database.AddInParameter(command, "@ReceiverId", DbType.Int32, receiverId);
                    database.AddInParameter(command, "@ChatSourceId", DbType.Int32, chatSourceId);
                    database.AddInParameter(command, "@PageNumber", DbType.Int32, pageNumber);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pageSize);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            // DataRow item = returndata.Tables[0].Rows[0];
                            string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                    : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                            messages.Add(new ChatMessage
                            {
                                ChatGroupId = item["ChatGroupId"].ToString(),
                                UserId = Convert.ToInt32(item["SenderId"].ToString()),
                                FileId = string.IsNullOrEmpty(item["ChatFileId"].ToString()) ? null : (int?)(Convert.ToInt32(item["ChatFileId"].ToString())),
                                Message = item["TextMessage"].ToString(),
                                ChatSourceId = Convert.ToInt32(item["ChatSourceId"].ToString()),
                                UserProfilePic = pic,
                                UserInstallId = item["UserInstallId"].ToString(),
                                UserFullname = item["Fullname"].ToString(),
                                MessageAt = Convert.ToDateTime(item["CreatedOn"].ToString()),
                                MessageAtFormatted = Convert.ToDateTime(item["CreatedOn"].ToString()).ToString(),
                                IsRead = Convert.ToBoolean(item["IsRead"].ToString()),
                                WelcomeEmailStatus = Convert.ToInt32(item["WelcomeEmailStatus"].ToString())
                            });
                        }
                    }
                    return new ActionOutput<ChatMessage>
                    {
                        Results = messages.OrderBy(m => m.MessageAt).ToList(),
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatMessage>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<ChatMessage> GetUserChatGroupAndChatGroup(int userId, int loggedInUserId)
        {
            try
            {
                List<ChatMessage> messages = new List<ChatMessage>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetUserChatGroupAndChatGroup");
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            // DataRow item = returndata.Tables[0].Rows[0];
                            messages.Add(new ChatMessage
                            {
                                ChatGroupId = item["ChatGroupId"].ToString(),
                                //UserId = Convert.ToInt32(item["SenderId"].ToString()),
                                //FileId = string.IsNullOrEmpty(item["ChatFileId"].ToString()) ? null : (int?)(Convert.ToInt32(item["ChatFileId"].ToString())),
                                Message = item["TextMessage"].ToString(),
                                //ChatSourceId = Convert.ToInt32(item["ChatSourceId"].ToString()),
                                MessageAt = Convert.ToDateTime(item["CreatedOn"].ToString()),
                                MessageAtFormatted = Convert.ToDateTime(item["CreatedOn"].ToString()).ToString(),
                                //IsRead = Convert.ToBoolean(item["IsRead"].ToString()),
                                UserChatGroupId = Convert.ToInt32(item["UserChatGroupId"].ToString()),
                                ReceiverIds = item["ReceiverIds"].ToString(),
                                ChatSourceId = Convert.ToInt32(item["ChatSourceId"].ToString())
                            });
                        }
                    }
                    return new ActionOutput<ChatMessage>
                    {
                        Results = messages,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatMessage>
                {
                    Results = new List<ChatMessage>(),
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<ChatUnReadCount> GetChatUnReadCount(int loggedInUserId)
        {
            try
            {
                List<ChatUnReadCount> messages = new List<ChatUnReadCount>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetChatUnReadCount");
                    database.AddInParameter(command, "@UserId", DbType.Int32, loggedInUserId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            messages.Add(new ChatUnReadCount
                            {
                                UserId = Convert.ToInt32(item["SenderId"].ToString()),
                                UnReadCount = Convert.ToInt32(item["UnReadCount"].ToString()),
                            });
                        }
                    }
                    return new ActionOutput<ChatUnReadCount>
                    {
                        Results = messages,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatUnReadCount>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<ActiveUser> GetAllChatHistory()
        {
            try
            {
                List<ActiveUser> users = new List<ActiveUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetAllChatHistory");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            // DataRow item = returndata.Tables[0].Rows[0];
                            string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                    : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                            users.Add(new ActiveUser
                            {
                                UserId = string.IsNullOrEmpty(item["UserId"].ToString()) ? null : (int?)Convert.ToInt32(item["UserId"].ToString()),
                                //ConnectionId = item["ConnectionId"].ToString(),
                                GroupOrUsername = item["GroupOrUsername"].ToString(),
                                //Email = item["Email"].ToString(),
                                ProfilePic = pic,
                                UserInstallId = item["UserInstallId"].ToString(),
                                OnlineAt = !string.IsNullOrEmpty(item["OnlineAt"].ToString()) ?
                                                    (DateTime?)Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST() : null,
                                OnlineAtFormatted = !string.IsNullOrEmpty(item["OnlineAt"].ToString()) ?
                                                        Convert.ToDateTime(item["OnlineAt"].ToString()).ToEST().ToString() : null,
                                LastMessage = item["LastMessage"].ToString(),
                                LastMessageAt = !string.IsNullOrEmpty(item["MessageAt"].ToString()) ?
                                                    (DateTime?)Convert.ToDateTime(item["MessageAt"].ToString()).ToEST() : null,
                                LastMessageAtFormatted = !string.IsNullOrEmpty(item["MessageAt"].ToString()) ?
                                                    Convert.ToDateTime(item["MessageAt"].ToString()).ToEST().ToString() : null,
                                IsRead = Convert.ToBoolean(item["IsRead"].ToString()),
                                ChatGroupId = item["ChatGroupId"].ToString(),
                                ReceiverIds = item["ReceiverIds"].ToString(),
                            });
                        }
                    }
                    return new ActionOutput<ActiveUser>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ActiveUser>
                {
                    Results = new List<ActiveUser>(),
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<ChatMessage> GetTaskChatMessages(int loggedInUserId, int chatSourceId, int TaskId,
                                            int pageNumber, int pageSize, int TaskMultilevelListId = 0)
        {
            try
            {
                List<ChatMessage> messages = new List<ChatMessage>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetTaskChatMessages");
                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    database.AddInParameter(command, "@TaskMultilevelListId", DbType.Int32, TaskMultilevelListId);
                    database.AddInParameter(command, "@ChatSourceId", DbType.Int32, chatSourceId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                    database.AddInParameter(command, "@PageNumber", DbType.Int32, pageNumber);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pageSize);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            // DataRow item = returndata.Tables[0].Rows[0];
                            string pic = "Employee/ProfilePictures/" + (string.IsNullOrEmpty(item["Picture"].ToString()) ? "default.jpg"
                                                    : item["Picture"].ToString().Replace("~/UploadeProfile/", ""));
                            messages.Add(new ChatMessage
                            {
                                ChatGroupId = item["ChatGroupId"].ToString(),
                                UserId = Convert.ToInt32(item["SenderId"].ToString()),
                                Message = item["TextMessage"].ToString(),
                                FileId = string.IsNullOrEmpty(item["ChatFileId"].ToString()) ? null : (int?)(Convert.ToInt32(item["ChatFileId"].ToString())),
                                ChatSourceId = Convert.ToInt32(item["ChatSourceId"].ToString()),
                                UserProfilePic = pic,
                                UserInstallId = item["UserInstallId"].ToString(),
                                UserFullname = item["Fullname"].ToString(),
                                MessageAt = Convert.ToDateTime(item["CreatedOn"].ToString()),
                                MessageAtFormatted = Convert.ToDateTime(item["CreatedOn"].ToString()).ToString(),
                                IsRead = Convert.ToBoolean(item["IsRead"].ToString()),
                                TaskId = string.IsNullOrEmpty(item["TaskId"].ToString()) ? null : (int?)(Convert.ToInt32(item["TaskId"].ToString())),
                                TaskMultilevelListId = string.IsNullOrEmpty(item["TaskMultilevelListId"].ToString()) ? 0 : (int?)(Convert.ToInt32(item["TaskMultilevelListId"].ToString())),
                                UserChatGroupId = string.IsNullOrEmpty(item["UserChatGroupId"].ToString()) ? null : (int?)(Convert.ToInt32(item["UserChatGroupId"].ToString())),
                            });
                        }
                    }
                    return new ActionOutput<ChatMessage>
                    {
                        Results = messages.OrderBy(m => m.MessageAt).ToList(),
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<ChatMessage>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public ActionOutput<int> GetTaskUsers(int TaskId)
        {
            List<int> users = new List<int>();
            try
            {
                List<ChatMessage> messages = new List<ChatMessage>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetTaskUsers");
                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            users.Add(Convert.ToInt32(item["UserId"].ToString()));
                        }
                    }
                    return new ActionOutput<int>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return new ActionOutput<int>
                {
                    Message = ex.Message,
                    Status = ActionStatus.Error
                };
            }
        }

        public DataSet GetSalesUsersStaticticsAndData(string strSearchTerm, string strStatus, string secondaryStatus, string intDesignationId,
                                    string intSourceId, DateTime? fromdate, DateTime? todate, string addedByUserId, int intPageIndex,
                                    int intPageSize, string strSortExpression, int LoggedInUserId, bool FirstTimeOpen = false)
        {
            DataSet dsResult = null;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetSalesUsers");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@FirstTimeOpen", DbType.Boolean, FirstTimeOpen);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, LoggedInUserId);

                    if (!string.IsNullOrEmpty(strSearchTerm))
                    {
                        database.AddInParameter(command, "@SearchTerm", DbType.String, strSearchTerm);
                    }
                    database.AddInParameter(command, "@Status", DbType.String, strStatus);
                    database.AddInParameter(command, "@SecondaryStatus", DbType.String, secondaryStatus);
                    database.AddInParameter(command, "@DesignationId", DbType.String, intDesignationId);
                    database.AddInParameter(command, "@SourceId", DbType.String, intSourceId);
                    database.AddInParameter(command, "@AddedByUserId", DbType.String, addedByUserId);
                    if (fromdate != null)
                    {
                        database.AddInParameter(command, "@FromDate", DbType.Date, fromdate);
                    }
                    else
                    {
                        database.AddInParameter(command, "@FromDate", DbType.Date, DBNull.Value);
                    }
                    if (todate != null)
                    {
                        database.AddInParameter(command, "@ToDate", DbType.Date, todate);
                    }
                    else
                    {
                        database.AddInParameter(command, "@ToDate", DbType.Date, DBNull.Value);
                    }

                    database.AddInParameter(command, "@PageIndex", DbType.Int16, intPageIndex);
                    database.AddInParameter(command, "@PageSize", DbType.Int16, intPageSize);
                    database.AddInParameter(command, "@SortExpression", DbType.String, strSortExpression);

                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());
                    database.AddInParameter(command, "@RejectedStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Rejected).ToString());

                    database.AddInParameter(command, "@OfferMadeStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.OfferMade).ToString());
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());

                    dsResult = database.ExecuteDataSet(command);
                }
                return dsResult;
            }
            catch (Exception ex)
            {
                return dsResult;
            }
        }

    }
}
