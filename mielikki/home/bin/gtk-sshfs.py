#!/usr/bin/python
# -*- coding: utf-8 -*-

##
#   Quick mount sshfs
#
#   by ADcomp <david.madbox@gmail.com>
#      http://www.ad-comp.be/
#
#   This program is distributed under the terms of the GNU General Public License
#   For more info see http://www.gnu.org/licenses/gpl.txt
##

import pexpect
import os
import gtk

## print debug info ( True / False )
DEBUG = False

class UI:
    def __init__(self):
        # Create window
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_title("Mount sshFS")
        self.window.set_position(gtk.WIN_POS_CENTER)
        self.window.connect("destroy", self.quit)

        # Containers
        BoxBase = gtk.VBox()
        #~ BoxBase.set_spacing(5)
        BoxBase.set_border_width(5)

        BoxMain = gtk.HBox()
        BoxMain.set_spacing(5)
        BoxMain.set_border_width(5)

        BoxControls = gtk.HButtonBox()
        #~ BoxControls.set_spacing(2)
        BoxControls.set_layout(gtk.BUTTONBOX_END)

        # Exit
        button_exit = gtk.Button(stock=gtk.STOCK_CLOSE)
        button_exit.connect("clicked", self.quit)
        BoxControls.pack_end(button_exit, False, False)

        table = gtk.Table()
        table.set_row_spacings(5)
        table.set_col_spacings(5)

        ## Label
        label = gtk.Label()
        label.set_markup("<b>New Connection</b>")
        label.set_alignment(0, 1)
        table.attach(label, 0, 2, 0, 1)

        ## User
        self.User_entry = gtk.Entry()
        self.User_entry.set_text(os.getenv('USER'))
        label = gtk.Label('User :')
        label.set_alignment(0, 1)
        table.attach(label, 0, 1, 1, 2)
        table.attach(self.User_entry, 1, 2, 1, 2)

        ## Password
        self.Password_entry = gtk.Entry()
        self.Password_entry.set_visibility(False)
        label = gtk.Label('Password :')
        label.set_alignment(0, 1)
        table.attach(label, 0, 1, 2, 3)
        table.attach(self.Password_entry, 1, 2, 2, 3)

        ## Host
        self.Host_entry = gtk.Entry()
        label = gtk.Label('Host :')
        label.set_alignment(0, 1)
        table.attach(label, 0, 1, 3, 4)
        table.attach(self.Host_entry, 1, 2, 3, 4)

        ## Dir
        self.Dir_entry = gtk.Entry()
        label = gtk.Label('Dir :')
        label.set_alignment(0, 1)
        table.attach(label, 0, 1, 4, 5)
        table.attach(self.Dir_entry, 1, 2, 4, 5)

        ## Mountpoint
        self.Mountpoint_entry = gtk.Entry()
        label = gtk.Label('Mountpoint :')
        label.set_alignment(0, 1)
        table.attach(label, 0, 1, 5, 6)
        table.attach(self.Mountpoint_entry, 1, 2, 5, 6)

        ## Port
        self.Port_entry = gtk.Entry()
        self.Port_entry.set_text('22')
        label = gtk.Label('Port :')
        label.set_alignment(0, 1)
        table.attach(label, 0, 1, 6, 7)
        table.attach(self.Port_entry, 1, 2, 6, 7)

        # Open directory
        self.OpenDir_checkbox = gtk.CheckButton('Open directory')
        self.OpenDir_checkbox.set_active(True)
        table.attach(self.OpenDir_checkbox, 0, 1, 7, 8)

        ## Connect
        self.Connect_Bt = gtk.Button(stock=gtk.STOCK_CONNECT)
        self.Connect_Bt.connect("clicked", self.mount_sshfs)
        table.attach(self.Connect_Bt, 1, 2, 7, 8)

        ## Separator
        table.attach(gtk.HSeparator(), 0, 2, 8, 9)

        ## Label
        label = gtk.Label()
        label.set_markup("<b>Mountpoint</b>")
        label.set_alignment(0, 1)
        table.attach(label, 0, 2, 9, 10)

        ## Mounted_FS
        self.Mounted_fs_combo = gtk.combo_box_new_text()
        table.attach(self.Mounted_fs_combo, 0, 2, 10, 11)

        ## Open / Umount
        self.Open_Bt = gtk.Button(stock=gtk.STOCK_OPEN)
        self.Open_Bt.connect("clicked", self.open_mountpoint)
        table.attach(self.Open_Bt, 0, 1, 11, 12)

        self.Umount_Bt = gtk.Button(stock=gtk.STOCK_DISCONNECT)
        self.Umount_Bt.connect("clicked", self.umount_sshfs)
        table.attach(self.Umount_Bt, 1, 2, 11, 12)

        ## Separator
        table.attach(gtk.HSeparator(), 0, 2, 12, 13)

        BoxMain.add(table)
        BoxBase.pack_start(BoxMain, True)
        BoxBase.pack_end(BoxControls, False)

        self.window.add(BoxBase)

        self.User_entry.connect("changed", self.auto_mountpoint)
        self.Host_entry.connect("changed", self.auto_mountpoint)

        self.update_mountedfs()

        #Show main window frame and all content
        self.window.show_all()

    def auto_mountpoint(self, widget):
        User = self.User_entry.get_text()
        Host = self.Host_entry.get_text()
        self.Mountpoint_entry.set_text('%s@%s' % (User, Host))

    def open_mountpoint(self, widget):
        mount_point = self.Mounted_fs_combo.get_active()
        if mount_point == 0 or mount_point == -1:
            return
        else:
            os.system('xdg-open %s' % self.Mounted_fs_combo.get_active_text())

    def umount_sshfs(self, widget):
        mount_point = self.Mounted_fs_combo.get_active()
        if mount_point == 0 or mount_point == -1:
            return
        else:
            os.system('fusermount -u %s' % self.Mounted_fs_combo.get_active_text())
            self.update_mountedfs()

    def update_mountedfs(self):
        self.mounted_fs_tab = get_mounted_fs()
        self.Mounted_fs_combo.get_model().clear()
        self.Mounted_fs_combo.insert_text(0, 'Choose')

        ind = 1
        for mounted_fs in self.mounted_fs_tab:
            self.Mounted_fs_combo.insert_text(ind, mounted_fs[1])
            ind += 1
        self.Mounted_fs_combo.set_active(0)

    def mount_sshfs(self, widget):
        User = self.User_entry.get_text()
        Password = self.Password_entry.get_text()
        Host = self.Host_entry.get_text()
        Dir = self.Dir_entry.get_text()

        Mountpoint = os.getenv('HOME') + '/' + self.Mountpoint_entry.get_text()
        if not os.path.exists(Mountpoint):
            os.mkdir(Mountpoint)

        Port = self.Port_entry.get_text()

        if User == '' or Password == '' or Host == '' or Mountpoint =='' or Port =='':
            #!FixME
            debug_info('Error : please check your config')
            show_msg('Error : please check your config')
            return

        sshfs = sshFs()
        ret = sshfs.mount(User, Password, Host, Dir, Mountpoint, Port)
        self.update_mountedfs()

        if ret[0] == 0:
            if self.OpenDir_checkbox.get_active():
                os.system('xdg-open %s' % Mountpoint)
        else:
            show_msg(ret[1])

    def run(self):
        gtk.main()

    def quit(self, widget=None, data=None):
        gtk.main_quit()

## Initialize the module.
class sshFs:
    def __init__(self):
        ## Three responses we might expect.
        self.Initial_Responses = ['Are you sure you want to continue connecting (yes/no)?',
                                  'password:', pexpect.EOF]

    def mount(self, User="", Password="", Host="", Dir="", Mountpoint="", Port=22, Timeout=120):

        Command = "sshfs -p %s %s@%s:%s %s" % (Port, User, Host, Dir, Mountpoint)
        debug_info("Command : %s" % Command)

        child = pexpect.spawn(Command)

        ## Get the first response.
        ret = child.expect (self.Initial_Responses, Timeout)
        ## The first reponse is to accept the key.
        if ret==0:
            debug_info("The first reponse is to accept the key.")
            #~ T = child.read(100)
            child.sendline("yes")
            child.expect('password:', Timeout)
            child.sendline(Password)
        ## The second response sends the password.
        elif ret == 1:
            debug_info("The second response sends the password.")
            child.sendline(Password)
        ## Otherwise, there is an error.
        else:
            debug_info("Otherwise, there is an error.")
            return (-3, 'ERROR: Unknown: ' + str(child.before))

        ## Get the next response.
        Possible_Responses = ['password:', pexpect.EOF]
        ret = child.expect (Possible_Responses, Timeout)

        ## If it asks for a password, error.
        if ret == 0:
            debug_info("If it asks for a password, error.")
            return (-4, 'ERROR: Incorrect password.')
        elif ret == 1:
            debug_info("Otherwise we are okay.")
            return (0, str(child.after))
            ## Otherwise we are okay.
        else:
            debug_info("Otherwise, there is an error.")
            return (-3, 'ERROR: Unknown: ' + str(child.before))

def show_msg(msg=' .. '):
    """  """
    message = gtk.MessageDialog(None, gtk.DIALOG_MODAL, gtk.MESSAGE_INFO, gtk.BUTTONS_OK, msg)
    resp = message.run()
    message.destroy()

def get_mounted_fs():
    """ get_mounted_fs() -> reads mtab and returns a list of mounted sshfs filesystems. """
    try:
        mounted_fs = []
        lines = [line.strip("\n").split(" ") for line in open ("/etc/mtab", "r").readlines()]
        for line in lines:
            if line[2] == "fuse.sshfs" and "user=%s" % os.getenv('USER') in line[3]:
                    mounted_fs.append((line[0], line[1]))
        return mounted_fs
    except:
        debug_info("Could not read mtab")
        show_msg("Could not read mtab .. :(")

def debug_info(msg):
    if DEBUG:
        print "# %s" % msg

if __name__ == "__main__":
    ui = UI()
    ui.run()
