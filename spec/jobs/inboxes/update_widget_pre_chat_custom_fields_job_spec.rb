require 'rails_helper'

RSpec.describe Inboxes::UpdateWidgetPreChatCustomFieldsJob do
  pre_chat_fields = [{
    'label' => 'Developer Id',
    'name' => 'developer_id'
  }, {
    'label' => 'Full Name',
    'name' => 'full_name'
  }]
  pre_chat_message = 'Share your queries here.'
  custom_attribute = {
    'attribute_key' => 'developer_id',
    'attribute_display_name' => 'Developer Number',
    'regex_pattern' => '^[0-9]*',
    'regex_cue' => 'It should be only digits'
  }
  let!(:account) { create(:account) }
  let!(:web_widget) do
    create(:channel_widget, account: account, pre_chat_form_options: { pre_chat_message: pre_chat_message, pre_chat_fields: pre_chat_fields })
  end

  context 'when called' do
    it 'sync pre chat fields if custom attribute updated' do
      described_class.perform_now(account, custom_attribute)
      expect(web_widget.reload.pre_chat_form_options['pre_chat_fields']).to eq [
        { 'label' => 'Developer Number', 'name' => 'developer_id', 'placeholder' => 'Developer Number',
          'values' => nil, 'regex_pattern' => '^[0-9]*', 'regex_cue' => 'It should be only digits' },
        { 'label' => 'Full Name', 'name' => 'full_name' }
      ]
    end
  end
end
