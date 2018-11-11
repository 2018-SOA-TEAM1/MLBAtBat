# frozen_string_literal: true

require_relative 'spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'
require_relative 'helpers/database_helper.rb'

describe 'Integration Tests of MLB API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_mlb
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end
    
    it 'HAPPY: should be able to save mlb schedule data to database' do
      
      schedule = MLBAtBat::MLB::ScheduleMapper
      .new
      .get_schedule(SPORT_ID, GAME_DATE)
      rebuilt_schedule = MLBAtBat::Repository::For.entity(schedule).create(schedule)
      _(rebuilt_schedule.pk).must_equal(schedule.pk)

      # branch domain
      pk = schedule.pk
      whole_game = Mapper::WholeGame.new.get_whole_game(game_pk)
      _(whole_game.inngings_num).must_equal(10)
      _(whole_game.live_play.homeScore).must_equal(8)
      _(whole_game.live_play.awayScore).must_equal(6)
    end    


  end



end
