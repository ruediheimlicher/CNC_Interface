
extern int rawhid_open(int max, int vid, int pid, int usage_page, int usage);
extern int rawhid_recv(int num, void *buf, int len, int timeout);
extern int rawhid_send(int num, uint8_t *buf, int len, int timeout);
extern void rawhid_close(int num);
extern int rawhid_status(void);
extern int get_hid_usbstatus(void);
extern int usb_present(void);
extern int findHIDDevicesWithVendorID(uint32_t vendorID);

extern const char* get_manu(void);
extern const char* get_prod(void);
extern int getX(void);
extern void  free_all_hid(void);

extern const int BufferSize(void);


