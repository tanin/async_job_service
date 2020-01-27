require 'rails_helper'

describe RunJobsController, type: :controller do
  describe '#show' do
    context 'when success' do
      # GET /email/:email_id/status?status=received
      it 'returns 201' do
        get :show, params: { queue_name: 'email', id: 123, state: 'status', status: 'received' }
        expect(response.status).to eq(204)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq(
          {
            uid: Digest::MD5.hexdigest('123'),
            message: 'Job enqueued successfully'
          }
        )
      end
    end

    context 'when fails' do
      context 'when queue not supported' do
        # GET /post/:email_id/status?status=received
        it 'returns 422' do
          get :show, params: { queue_name: 'post', id: 123, state: 'status', status: 'received' }
          expect(response.status).to eq(400)
          expect(JSON.parse(response.body, symbolize_names: true)).to eq(
            {
              error: 'service is not able to apply this request'
            }
          )
        end
      end

      context 'when validation error' do
        # GET /post/:email_id/status
        it 'returns 422' do
          get :show, params: { queue_name: 'post', id: 123, state: 'status' }
          expect(response.status).to eq(400)
          expect(JSON.parse(response.body, symbolize_names: true)).to eq(
            {
              error: 'data must include status key'
            }
          )
        end
      end
    end
  end
end
