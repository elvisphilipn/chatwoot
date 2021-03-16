<template>
  <div class="wizard-body small-9 columns">
    <page-header
      :header-title="$t('INBOX_MGMT.ADD.LINE.TITLE')"
      :header-content="$t('INBOX_MGMT.ADD.LINE.DESC')"
    />
    <form class="row" @submit.prevent="createChannel()">
      <div class="medium-8 columns">
        <label :class="{ error: $v.channelName.$error }">
          {{ $t('INBOX_MGMT.ADD.LINE.CHANNEL_NAME.LABEL') }}
          <input
            v-model.trim="channelName"
            type="text"
            :placeholder="$t('INBOX_MGMT.ADD.LINE.CHANNEL_NAME.PLACEHOLDER')"
            @blur="$v.channelName.$touch"
          />
          <span v-if="$v.channelName.$error" class="message">{{
            $t('INBOX_MGMT.ADD.LINE.CHANNEL_NAME.ERROR')
          }}</span>
        </label>
      </div>

      <div class="medium-8 columns">
        <label :class="{ error: $v.channelID.$error }">
          {{ $t('INBOX_MGMT.ADD.LINE.CHANNEL_ID.LABEL') }}
          <input
            v-model.trim="channelID"
            type="text"
            :placeholder="$t('INBOX_MGMT.ADD.LINE.CHANNEL_ID.PLACEHOLDER')"
            @blur="$v.channelID.$touch"
          />
          <span v-if="$v.channelID.$error" class="message">{{
            $t('INBOX_MGMT.ADD.LINE.CHANNEL_ID.ERROR')
          }}</span>
        </label>
      </div>

      <div class="medium-8 columns">
        <label :class="{ error: $v.channelToken.$error }">
          {{ $t('INBOX_MGMT.ADD.LINE.CHANNEL_TOKEN.LABEL') }}
          <input
            v-model.trim="channelToken"
            type="text"
            :placeholder="$t('INBOX_MGMT.LINE.CHANNEL_TOKEN.PLACEHOLDER')"
            @blur="$v.channelToken.$touch"
          />
          <span v-if="$v.channelToken.$error" class="message">{{
            $t('INBOX_MGMT.ADD.LINE.CHANNEL_TOKEN.ERROR')
          }}</span>
        </label>
      </div>

      <div class="medium-8 columns">
        <label :class="{ error: $v.channelSecret.$error }">
          {{ $t('INBOX_MGMT.ADD.LINE.CHANNEL_SECRET.LABEL') }}
          <input
            v-model.trim="channelSecret"
            type="password"
            :placeholder="$t('INBOX_MGMT.LINE.CHANNEL_SECRET.PLACEHOLDER')"
            @blur="$v.channelSecret.$touch"
          />
          <span v-if="$v.channelSecret.$error" class="message">{{
            $t('INBOX_MGMT.ADD.LINE.CHANNEL_SECRET.ERROR')
          }}</span>
        </label>
      </div>

      <div class="medium-12 columns">
        <woot-submit-button
          :loading="uiFlags.isCreating"
          :button-text="$t('INBOX_MGMT.ADD.LINE.SUBMIT_BUTTON')"
        />
      </div>
    </form>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import alertMixin from 'shared/mixins/alertMixin';
import { required } from 'vuelidate/lib/validators';
import router from '../../../../index';
import PageHeader from '../../SettingsSubPageHeader';

export default {
  components: {
    PageHeader,
  },
  mixins: [alertMixin],
  data() {
    return {
      channelID: '',
      channelToken: '',
      channelSecret: '',
      channelName: '',
    };
  },
  computed: {
    ...mapGetters({
      uiFlags: 'inboxes/getUIFlags',
    }),
  },
  validations: {
    channelName: { required },
    channelID: { required },
    channelToken: { required },
    channelSecret: { required },
  },
  methods: {
    async createChannel() {
      this.$v.$touch();
      if (this.$v.$invalid) {
        return;
      }

      try {
        const lineChannel = await this.$store.dispatch(
          'inboxes/createLineChannel',
          {
            line_channel: {
              name: this.channelName,
              channel_id: this.channelID,
              channel_token: this.channelToken,
              channel_secret: this.channelSecret,
            },
          }
        );

        router.replace({
          name: 'settings_inboxes_add_agents',
          params: {
            page: 'new',
            inbox_id: lineChannel.id,
          },
        });
      } catch (error) {
        this.showAlert(this.$t('INBOX_MGMT.ADD.LINE.API.ERROR_MESSAGE'));
      }
    },
  },
};
</script>
