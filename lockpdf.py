import argparse
from pypdf import PdfReader, PdfWriter
import tkinter as tk
import os
import sys

class ModernPasswordDialog:
    def __init__(self):
        self.password = None
        self.root = tk.Tk()
        self.root.overrideredirect(True)
        self.setup_window()
        self.create_widgets()

    def setup_window(self):
        self.root.geometry("300x230")
        self.root.configure(bg='#2c3e50')
        self.root.attributes('-topmost', True)

        self.root.update_idletasks()
        x = (self.root.winfo_screenwidth() // 2) - (350 // 2)
        y = (self.root.winfo_screenheight() // 2) - (260 // 2)
        self.root.geometry(f"350x260+{x}+{y}")
        self.root.focus_force()

    def create_widgets(self):
        drag_data = {'x': 0, 'y': 0}
        def start_move(event):
            drag_data['x'] = event.x
            drag_data['y'] = event.y
        def do_move(event):
            x = self.root.winfo_x() + (event.x - drag_data['x'])
            y = self.root.winfo_y() + (event.y - drag_data['y'])
            self.root.geometry(f"+{x}+{y}")

        top_frame = tk.Frame(self.root, bg='#2c3e50', height=32, cursor='hand2')
        top_frame.pack(fill='x', pady=(0, 0))
        top_frame.pack_propagate(False)
        
        top_frame.bind("<Button-1>", start_move)
        top_frame.bind("<B1-Motion>", do_move)

        close_btn = tk.Button(
            top_frame, text="×", font=("Arial", 14, "bold"),
            bg='#2c3e50', fg='white', relief='flat', bd=0,
            command=self.cancel_clicked, cursor='hand2'
        )
        close_btn.pack(side='right', padx=8, pady=0)
        close_btn.bind("<Enter>", lambda e: close_btn.config(fg='#e74c3c', bg='#34495e'))
        close_btn.bind("<Leave>", lambda e: close_btn.config(fg='white', bg='#2c3e50'))

        title_label = tk.Label(
            top_frame, text="Lock PDF", font=("Arial", 12, "bold"),
            bg='#2c3e50', fg='white', cursor='hand2'
        )
        title_label.pack(side='left', padx=5, pady=(0, 0), anchor='w')
        title_label.bind("<Button-1>", start_move)
        title_label.bind("<B1-Motion>", do_move)

        main_frame = tk.Frame(self.root, bg='#2c3e50', padx=10, pady=10)
        main_frame.pack(fill='both', expand=True)

        tk.Label(main_frame, text="🔐", font=("Arial", 26),
                 bg='#2c3e50', fg='#f39c12').pack()

        tk.Label(main_frame, text="Lock PDF with Password",
                 font=("Arial", 14, "bold"),
                 bg='#2c3e50', fg='white').pack(pady=(5, 0))

        tk.Label(main_frame, text="Enter a secure password to protect your PDF",
                 font=("Arial", 10),
                 bg='#2c3e50', fg='#bdc3c7').pack(pady=(2, 5))

        tk.Label(main_frame, text="Password:",
                 font=("Arial", 10, "bold"),
                 bg='#2c3e50', fg='white').pack(anchor='w', pady=(0, 5), padx=(30,0))

        self.password_var = tk.StringVar()
        self.password_entry = tk.Entry(main_frame, textvariable=self.password_var,
                                       font=("Arial", 12), show='*',
                                       bg='#34495e', fg='#ecf0f1',
                                       insertbackground='#ecf0f1',
                                       relief='flat', bd=0,
                                       highlightthickness=2,
                                       highlightcolor='#3498db',
                                       highlightbackground='#7f8c8d')
        self.password_entry.config(width=30)
        self.password_entry.pack(ipady=8)

        self.password_entry.focus()
        self.password_entry.bind('<Return>', lambda e: self.ok_clicked())

        btn_frame = tk.Frame(main_frame, bg='#2c3e50')
        btn_frame.pack(fill='x', pady=(20, 0))

    def create_button(self, parent, text, command, bg_color, hover_color):
        btn = tk.Button(
            parent,
            text=text,
            command=command,
            font=("Arial", 11, "bold"),
            bg=bg_color,
            fg='white',
            relief='flat',
            bd=0,
            width=16,
            cursor='hand2'
        )
        btn.pack(side='right', padx=(10, 0), ipady=10)
        btn.bind('<Enter>', lambda e: btn.configure(bg=hover_color))
        btn.bind('<Leave>', lambda e: btn.configure(bg=bg_color))



    def ok_clicked(self):
        self.password = self.password_var.get()
        self.root.destroy()

    def cancel_clicked(self):
        self.password = None
        self.root.destroy()

    def show(self):
        self.root.mainloop()
        return self.password


def ask_password():
    dialog = ModernPasswordDialog()
    return dialog.show()

def show_clean_message():
    import tkinter as tk

    root = tk.Tk()
    root.withdraw()

    msg_window = tk.Toplevel()
    msg_window.overrideredirect(True)
    msg_window.configure(bg='#2c3e50')
    msg_window.geometry("300x200")
    msg_window.attributes('-topmost', True)

    msg_window.update_idletasks()
    x = (msg_window.winfo_screenwidth() // 2) - (300 // 2)
    y = (msg_window.winfo_screenheight() // 2) - (200 // 2)
    msg_window.geometry(f"300x200+{x}+{y}")

    def close_window():
        msg_window.destroy()
        root.destroy()

    drag_data = {'x': 0, 'y': 0}
    def start_move(event):
        drag_data['x'] = event.x
        drag_data['y'] = event.y
    def do_move(event):
        x = msg_window.winfo_x() + (event.x - drag_data['x'])
        y = msg_window.winfo_y() + (event.y - drag_data['y'])
        msg_window.geometry(f"+{x}+{y}")

    top_frame = tk.Frame(msg_window, bg='#2c3e50', height=40)
    top_frame.pack(fill='x')
    top_frame.pack_propagate(False)
    
    top_frame.bind("<Button-1>", start_move)
    top_frame.bind("<B1-Motion>", do_move)

    close_btn = tk.Button(
        top_frame, text="×", font=("Arial", 16, "bold"),
        bg='#2c3e50', fg='white', relief='flat', bd=0, padx=10,
        command=close_window, cursor='hand2'
    )
    close_btn.pack(side='right', pady=4, padx=8)
    close_btn.bind("<Enter>", lambda e: close_btn.config(fg='#e74c3c', bg='#34495e'))
    close_btn.bind("<Leave>", lambda e: close_btn.config(fg='white', bg='#2c3e50'))

    title_label = tk.Label(
        top_frame, text="Lock PDF", font=("Arial", 12, "bold"),
        bg='#2c3e50', fg='white', cursor='hand2'
    )
    title_label.pack(side='left', padx=5, pady=8, anchor='w')
    title_label.bind("<Button-1>", start_move)
    title_label.bind("<B1-Motion>", do_move)

    content = tk.Frame(msg_window, bg='#2c3e50')
    content.pack(fill='both', expand=True)

    tk.Label(content, text="⚠️", font=("Arial", 24),
             bg='#2c3e50', fg='#f39c12').pack(pady=(10, 5))

    tk.Label(content, text="This PDF is already password-protected.\nYou cannot lock a locked file.",
             font=("Arial", 10), bg='#2c3e50', fg='#bdc3c7',
             justify='center').pack(pady=(0, 20))

    ok_btn = tk.Button(
        content, text="OK", command=close_window,
        font=("Arial", 11, "bold"),
        bg='#3498db', fg='white', relief='flat', bd=0,
        cursor='hand2'
    )
    ok_btn.place(relx=0.5, rely=0.92, anchor='s', width=120, height=38)


    ok_btn.bind("<Enter>", lambda e: ok_btn.configure(bg='#2980b9'))
    ok_btn.bind("<Leave>", lambda e: ok_btn.configure(bg='#3498db'))

    msg_window.bind('<Escape>', lambda e: close_window())
    msg_window.focus_set()
    msg_window.mainloop()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("src_pdf", help="Path to the PDF file")
    args = parser.parse_args()

    src = args.src_pdf
    src_dir = os.path.dirname(os.path.abspath(src))
    src_name = os.path.basename(src)
    dst_name = src_name.replace(".pdf", "_locked.pdf")
    dst = os.path.join(src_dir, dst_name)

    password = ask_password()
    if not password:
        return

    try:
        pdf_r = PdfReader(src)
        if pdf_r.is_encrypted:
            show_clean_message()
            return

        pdf_w = PdfWriter()
        for page in pdf_r.pages:
            pdf_w.add_page(page)
        pdf_w.encrypt(user_password=password)

        with open(dst, "wb") as f_out:
            pdf_w.write(f_out)
        os.remove(src)

        os.startfile(dst)
    except Exception as e:
        show_clean_message()

if __name__ == "__main__":
    main()
