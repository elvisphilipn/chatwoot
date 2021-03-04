import Facebook from './channels/Facebook';
import Website from './channels/Website';
import Twitter from './channels/Twitter';
import Twilio from './channels/Twilio';
import Api from './channels/Api';
import Email from './channels/Email';
import Line from './channels/Line';

const channelViewList = {
  facebook: Facebook,
  website: Website,
  twitter: Twitter,
  twilio: Twilio,
  api: Api,
  email: Email,
  line: Line,
};

export default {
  create() {
    return {
      props: {
        channel_name: {
          type: String,
          required: true,
        },
      },
      name: 'new-channel-view',
      render(h) {
        return h(channelViewList[this.channel_name] || null);
      },
    };
  },
};
