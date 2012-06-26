cron "Re-run transcode_worker::do_start_workers" do
  minute "*/2"
  user "root"
  command "rs_run_recipe -n transcode_worker::do_start_workers 2>&1 > /var/log/rs_sys_reconverge.log"
  action :delete
end