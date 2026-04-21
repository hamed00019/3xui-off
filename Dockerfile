# ۱. دریافت ایمیج پایه اوبونتو از مخزن ایران‌سرور (به جای داکر هاب)
FROM docker.arvancloud.ir/ubuntu:22.04

# جلوگیری از متوقف شدن نصب به خاطر سوالات تایم‌زون
ENV DEBIAN_FRONTEND=noninteractive

# ۲. تغییر آدرس دانلود بسته‌های اوبونتو به سرورهای داخلی ایران
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirror.arvancloud.ir/ubuntu/|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com/ubuntu/|http://mirror.arvancloud.ir/ubuntu/|g' /etc/apt/sources.list

# ۳. آپدیت و نصب پیش‌نیازها با سرعت بالا از داخل شبکه ایران
RUN apt-get update && apt-get install -y ca-certificates tzdata && rm -rf /var/lib/apt/lists/*

# ۴. کپی کردن فایل فشرده پنل (که از قبل دانلود کردی) به داخل سرور
COPY x-ui-linux-amd64.tar.gz /tmp/

# ۵. استخراج فایل‌ها و دادن دسترسی اجرایی
RUN mkdir -p /usr/local/x-ui \
    && tar zxvf /tmp/x-ui-linux-amd64.tar.gz -C /usr/local/x-ui --strip-components=1 \
    && chmod +x /usr/local/x-ui/x-ui \
    && chmod +x /usr/local/x-ui/bin/xray-linux-amd64 \
    && rm /tmp/x-ui-linux-amd64.tar.gz

# تنظیم مسیر کاری
WORKDIR /usr/local/x-ui/

# ۶. راه‌اندازی اولیه و تنظیم یوزر و پسورد
RUN ./x-ui setting -username admin -password admin -port 2053

# باز کردن پورت پنل
EXPOSE 2053

# دستور استارت همیشگی
CMD ["./x-ui"]