import ApiClient from '../ApiClient';

class LineClient extends ApiClient {
  constructor() {
    super('channels/line_channel', { accountScoped: true });
  }
}

export default new LineClient();
