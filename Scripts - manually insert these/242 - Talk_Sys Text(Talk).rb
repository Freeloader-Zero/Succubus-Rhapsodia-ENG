#==============================================================================
# �� Talk_Sys(������` 5)
#------------------------------------------------------------------------------
#   �����̌���������A�\�����邽�߂̃N���X�ł��B
#   ���̃N���X�̃C���X�^���X�� $msg �ŎQ�Ƃ���܂��B
#   �����ł̓g�[�N���̃V�`���G�[�V�������Ƃ̃e�L�X�g��ݒ肵�܂�
#==============================================================================
class Talk_Sys
  #============================================================================
  # ���g�[�N���̃e�L�X�g�ݒ�(����\���O�̃e�L�X�g)
  #============================================================================
  def make_text_aftertalk
    speaker = $msg.t_enemy.name #��b���̃G�l�~�[��
    master = $game_actors[101].name #��l����
    #���݂���Ȃ�A�p�[�g�i�[��
    if $msg.t_partner != nil
      servant = $msg.t_partner.name
    else
      servant = nil
    end
    m = ""
    case $msg.tag
    #==============================================================================
    # ����b�s������
    #==============================================================================
    when "�s����"
      case $msg.at_type
      when "�����N���C�V�X"
        m = "#{speaker} is i����ersed in pleasure...!\m\n It's i��possible to talk right no��...!"
      when "��l���N���C�V�X"
        m = "#{master} stares off vacantly...!\m\n can't focus right no��!"
      when "�����Ⓒ��"
        m = "#{speaker} is cli��axing....! \m\n She incapable of talking right no��!"
      when "���s�ߑ�"
        m = "For so��e reason, #{speaker} doesn't see��\n\m to ��ant to talk any��ore...."
      when "����������"
        m = "#{speaker} bears blissful expression....! \m\n She incapable of talking right no��!"
        m = "#{speaker} has a transfixed look on her face....!\m\n She see��s unable to talk right no��...!" if $msg.t_enemy.holding?
      when "�����\����"
        m = "#{speaker} is violently aroused....!\m\n She can't talk right no��!"
      end
    #==============================================================================
    # ����l���E��
    #==============================================================================
    when "��l���E��"
      case $msg.talk_step
      when 2 #�E�߂��󂯓��ꂽ�ꍇ
        m = "#{master} does as #{speaker} says, \m\n taking off his o��n clothes!"
      when 77 #�E�߂����ۂ����ꍇ
        m = "#{master} declined!"
      end
    #==============================================================================
    # �����ԒE��
    #==============================================================================
    when "���ԒE��"
      case $msg.talk_step
      when 2 #���Ԃ̒E�߂��󂯓��ꂽ�ꍇ
        m = "#{master} does as #{speaker} says,\m\n stripping #{servant} of her clothes!"
      when 77 #���Ԃ̒E�߂����ۂ����ꍇ
        m = "#{master} refused her de��ands!"
      end
    #==============================================================================
    # �������E��
    #==============================================================================
    when "�����E��"
      case $msg.talk_step
      when 2 #�E�߂����������ꍇ
        m = "#{master} does as she says, ��atching as\m\n #{speaker} continued to undresses herself!"
        m = "#{master} unintentionally kept ��atching as \m\n#{speaker} she undressed herself!" if $data_SDB[$msg.t_enemy.class_id].name == "�L���X�g"
        m = "#{master} ��atches hungrily, as #{speaker}\m\n continued undressing herself!" if $game_actors[101].state?(35)
      when 77 #�E�߂����Ȃ������ꍇ
        m = "#{master} struggled to pull a��ay,\m\n averting his eyes fro�� #{speaker}!"
      end
    #==============================================================================
    # ���z���E��
    #==============================================================================
    when "�z���E��"
      case $msg.talk_step
      when 2 #�z�����󂯓��ꂽ�ꍇ
        m = "#{speaker} locks lips ��ith #{master}!\m\n #{master}'s energy is being drained out of his body...!"
      when 77 #�z�������ۂ����ꍇ
        m = "#{master} declined her de��and!"
      end
    #==============================================================================
    # ���z���E����
    #==============================================================================
    when "�z���E����"
      case $msg.talk_step
      when 2 #�z�����󂯓��ꂽ�ꍇ
        m = "#{speaker} hungrily sucks on #{master}'s penis!\m\n #{master}'s strength is being drained and replaced\m\n by pleasure...!"
      when 77 #�z�������ۂ����ꍇ
        m = "#{master} declined her de��and!"
      end
    #==============================================================================
    # ���D��
    #==============================================================================
    when "�D��"
      m = "#{speaker}�͖��X�ł��Ȃ��悤���c�c�I"
    #==============================================================================
    # ������
    #==============================================================================
    when "����"
      case $msg.talk_step
      when 77 #�������ŏ����猩�Ȃ������ꍇ
        m = "#{master} resists te��ptation,\m\n averting his eyes fro�� #{speaker}!"
      when 78 #������r���Œf�����ꍇ
        m = "#{master} ��anages to peel a��ay,\m\n averting his eyes fro�� #{speaker}!"
      when 79 #�����������Ė\�������ꍇ
        m = "#{master} cannot look a��ay fro�� the sight before his eyes,\m\n falling to #{speaker}'s te��ptation!"
      #�p�����Ă���ꍇ
      else
        m = "#{speaker} seeks to satisfy her desires....!"
        emotion = ""
        case $msg.t_enemy.personality
        when "�Ӓn��","����","�|��"
          emotion = " suggestively"
          emotion = " approaches #{master} and" if rand($mood.point) > 50
        when "�D�F","����","�z�C","�_�a","�����C"
          emotion = " stares at #{master} and le��dly"
          emotion = ", ��eeting #{master}'s gaze," if rand($mood.point) > 50
        when "�W��","�]��","�Â���","�s�v�c"
          emotion = ", absorbed in her act,"
          emotion = ", feeling #{master}'s gaze," if rand($mood.point) > 50
        when "���C","��i","�V�R"
          emotion = " turns her face a��ay as she slo��ly"
          emotion = " blushes as she" if rand($mood.point) > 50
        end
        #�e�L�X�g���`(���A�K�n�͌��݂͕���̂��߁A�����ʂɊ���U��)
        case $msg.at_parts
        #�������Ŏ���
        when "�ΏہF��","�ΏہF��"
          if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            m = "#{speaker}#{emotion} runs her\m\n hands over her #{$msg.t_enemy.bustsize}!"
            m = "#{speaker}#{emotion} traces her\m\n nipple ��ith her finger!" if rand($mood.point) > 50
          else
            m = "#{speaker}#{emotion} s��ueezes her m\n #{$msg.t_enemy.bustsize} ��ith her hands!"
            m = "#{speaker}#{emotion} traces her\m\n nipple ��ith her finger!" if rand($mood.point) > 50
          end
        #�A�\�R�Ɏw����Ŏ���
        when "�ΏہF�A�\�R","�ΏہF�K"
          m = "#{speaker}#{emotion} rubs her\m\n fingers in and out of her pussy!"
          m = "#{speaker}#{emotion} thrusts her\m\n fingers in and out of her pussy!" if rand($mood.point) > 50
        #�A�j��M���Ď���
        when "�ΏہF�A�j","�ΏہF�A�i��"
          m = "#{speaker}#{emotion} rubs her\m\n clit ��ith her finger!"
          m = "#{speaker}#{emotion} violently rubs\m\n her clit ��ith her fingers!" if rand($mood.point) > 50
        end
      end
    #==============================================================================
    # ����d
    #==============================================================================
    when "��d"
      case $msg.talk_step
      when 77 #�������ŏ����猩�Ȃ������ꍇ
        m = "#{master}�͗U�f�ɕ������A\m\n#{speaker}�̗v����f�����I"
        m = "#{master}�͌�딯���������v���ŁA\m\n���Ƃ�#{speaker}�̗v����f�����I" if $game_actors[101].state?(35)
      when 78 #������r���Œf�����ꍇ
        m = "#{master} ��anages to peel a��ay,\m\n#{speaker}�ւ̕�d�̎���~�߂��I"
      when 79 #�����������Ė\�������ꍇ
        m = "#{master}�͔M�ɕ������ꂽ�悤�ɁA#{speaker}�ւ̕�d�𑱂��Ă���c�c�I"
      #�p�����Ă���ꍇ
      else
        m = "#{master}��#{speaker}�����������I"
        action = ""
        action = "�X��" if $msg.talk_step > 3
        action = "������"if $msg.chain_attack == true and $msg.talk_step > 3
        action = "�U���邪�܂܂�" if $game_switches[89] == true
        #�e�L�X�g���`
        case $msg.at_parts
        #�L�b�X�ŕ�d
        when "�ΏہF��"
          m = "#{master}��#{action}�A\m\n#{speaker}�ƌ����Ő�𗍂߂������I"
        #�������ɕ�d
        when "�ΏہF��"
          if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            m = "#{master}��#{action}�A\m\n#{speaker}��#{$msg.t_enemy.bustsize}�𝆂݂��������I"
            m = "#{master}��#{action}�A\m\n#{speaker}��#{$msg.t_enemy.bustsize}�����r�߉񂵂��I" if $game_variables[17] > 50 
          else
            m = "#{master}��#{action}�A\m\n#{speaker}��#{$msg.t_enemy.bustsize}����ŕ��ŉ񂵂��I"
            m = "#{master}��#{action}�A\m\n#{speaker}��#{$msg.t_enemy.bustsize}�����r�߉񂵂��I" if $game_variables[17] > 50 
          end
        #�A�\�R�ɕ�d
        when "�ΏہF�A�\�R","�ΏہF�A�i��"
          m = "#{master}��#{action}�A\m\n#{speaker}�̃A�\�R�Ɏw�𔲂��}�������I"
          m = "#{master}��#{action}�A\m\n#{speaker}�̃A�\�R�ɐ���o�����ꂵ���I" if $game_variables[17] > 50 
        #�A�j�ɕ�d
        when "�ΏہF�A�j"
          m = "#{master}��#{action}�A\m\n#{speaker}�̉A�j���w�ň��������I"
          m = "#{master}��#{action}�A\m\n#{speaker}�̉A�j�����r�ߏグ���I" if $game_variables[17] > 50 
        #���K�ɕ�d
        when "�ΏہF�K"
          m = "#{master}��#{action}�A\m\n#{speaker}�̂��K�𗼎�ň��������I"
          m = "#{master}��#{action}�A\m\n#{speaker}�̂��K�����r�߉񂵂��I" if $game_variables[17] > 50 
        #�A�i���ɕ�d
#        when "�ΏہF�A�i��"
#          m = "#{master}��#{action}�A\m\n#{speaker}�̋e�����w�ň��������I"
#          m = "#{master}��#{action}�A\m\n#{speaker}�̋e�������r�߉񂵂��I" if $game_variables[17] > 50 
        end
      end
    #==============================================================================
    # �������E����
    #==============================================================================
    when "�����E����"
      case $msg.talk_step
      when 77 #�������ŏ�����f�����ꍇ
        m = "#{master} resists te��ptation,\m\n and #{speaker}'s proposal!"
        m = "#{master} reluctantly tears a��ay,\m\n declining #{speaker}'s proposal!" if $game_actors[101].state?(35)
      when 78 #������r���Œf�����ꍇ
        m = "#{master} ��anages to peel a��ay,\m\n stopping #{speaker} ��id-thrust!"
      #���������󂯓��ꂽ�ꍇ
      else
        case $msg.at_parts
        #���C���T�[�g�E�A�N�Z�v�g
        #--------------------------------------------------------------------------
        when "���}���F�A�\�R��","�K�}���F�K��"
          if $game_variables[17] > 70
            if $game_actors[101].critical == true
              action = ["le��dly","tightly","firmly"]
              action = action[rand(action.size)]
              move = ["tightens around","strangles","s��ueezes"]
              move = move[rand(move.size)]
            else
              action = ""
              move = "���ߕt����"
            end
            hole = "pussy"
            hole = "ass" if $msg.at_parts == "�K�}���F�K��"
            m = "#{speaker}'s #{hole}\m\n #{action} #{move} #{master}'s penis�I" 
          else
            if $game_actors[101].critical == true
              if $msg.t_enemy.initiative_level > 0
                #��
                action = "holds #{master} do��n"
                #��
                waist = ["boldly fucks","po��erfully fucks","intensely fucks"]
                waist.push("undulatingly fucks","le��dly fucks","��ildly fucks") if $msg.t_enemy.positive?
                waist.push("strenuously fucks","devotedly fucks","lazily fucks") if $msg.t_enemy.negative?
              else
                #��
                action = "entrusts herself to #{master}"
                #��
                waist = ["po��erfully fucks"]
                waist.push("le��dly fucks") if $msg.t_enemy.positive?
                waist.push("strenuously fucks") if $msg.t_enemy.negative?
              end
              waist = waist[rand(waist.size)]
            else
              if $msg.t_enemy.initiative_level > 0
                #��
                action = "gazes at #{master}"
                #��
                waist = ["slo��ly fucks","bounces on top of","gyrates on top"]
                waist.push("teasingly fucks","co��fortably fucks") if $msg.t_enemy.positive?
                waist.push("��odestly fucks","sha��efully fucks") if $msg.t_enemy.negative?
              else
                #��
                action = "��atches #{master}'s pace"
                #��
                waist = ["slo��ly fucks"]
                waist.push("teasingly fucks") if $msg.t_enemy.positive?
                waist.push("��odestly fucks") if $msg.t_enemy.negative?
              end
              waist = waist[rand(waist.size)]
            end
            m = "#{speaker} #{action} as she #{waist} hi��!"
          end
        #���I�[����
        #--------------------------------------------------------------------------
        when "���}���F����"
          if $game_actors[101].critical == true
            if $msg.t_enemy.initiative_level > 0
              #��
              action = "sucks"
              #��
              mouth = ["boldly","noisily","intensely"]
              mouth.push("deeply","le��dly","��ildly") if $msg.t_enemy.positive?
              mouth.push("strenuously","devotedly","lazily") if $msg.t_enemy.negative?
              mouth.push("a��orously") if $mood.point > 70
            else
              #��
              action = "deepthroats"
              #��
              mouth = ["boldly"]
              mouth.push("le��dly") if $msg.t_enemy.positive?
              mouth.push("streneously") if $msg.t_enemy.negative?
              mouth.push("a��orously") if $mood.point > 70
            end
            mouth = mouth[rand(mouth.size)]
          else
            if $msg.t_enemy.initiative_level > 0
              #��
              action = "sucks"
              #��
              mouth = ["slo��ly"]
              mouth.push("teasingly","co��fortably") if $msg.t_enemy.positive?
              mouth.push("ti��idly","��odestly","sha��efully") if $msg.t_enemy.negative?
              mouth.push("a��orously") if $mood.point > 70
            else
              #��
              action = "deepthroats"
              #��
              mouth = ["slo��ly"]
              mouth.push("teasingly","gradually") if $msg.t_enemy.positive?
              mouth.push("ti��idly","hesitantly") if $msg.t_enemy.negative?
            end
            mouth = mouth[rand(mouth.size)]
          end
          m = "#{speaker} #{mouth} #{action} #{master}'s penis!"
        #���p�C�Y��
        #--------------------------------------------------------------------------
        when "�p�C�Y��"
          if $game_actors[101].critical == true
            action = "fucks"
            #��
            bust = ["boldly","deliberately"]
            bust.push("le��dly","po��erfully") if $msg.t_enemy.positive?
            bust.push("strenuously","devotedly","lazily") if $msg.t_enemy.negative?
            bust.push("a��orously") if $mood.point > 70
          else
            action = "sand��iches"
            #��
            bust = ["slo��ly","tightly"]
            bust.push("teasingly","co��fortably") if $msg.t_enemy.positive?
            bust.push("ti��idly","��odestly","sha��efully") if $msg.t_enemy.negative?
            bust.push("a��orously") if $mood.point > 70
          end
          bust = bust[rand(bust.size)]
          m = "#{speaker} #{bust} #{action} #{master}'s penis\m\n ��ith her #{$msg.t_enemy.bustsize}!"
        #--------------------------------------------------------------------------
        when "�w�ʍS��"
          action = []
          if $game_actors[101].critical == true
            action.push("�̎�؂�����r�߂Ă����I")
            action.push("�̎����Ԃ��Ê��݂��Ă����I")
            action.push("�̓��������r�߂Ă����I")
            action.push("�Ɏ����̋��������t���Ă����I")
            #�y�j�X���󂢂Ă���ꍇ
            if $game_actors[101].hold.penis.battler == nil
              action.push("�̃y�j�X���w�ŘM���Ă����I") 
              action.push("�̃y�j�X���w��ŕ��łĂ����I")
            #�y�j�X���C���T�[�g���̏ꍇ(�A�i���܂�)
            elsif $game_actors[101].penis_insert? or $game_actors[101].penis_analsex?
              hold_target = $game_actors[101].hold.penis.battler
              action.push("�̍���O�ɉ����o�����I\m\n#{hold_target}�Ƃ̌����������[���Ȃ����I")
            #�y�j�X���p�C�Y�����̏ꍇ
            elsif $game_actors[101].penis_paizuri?
              action.push("�̍������������񂾁I\m\n#{hold_target}�̓������X�Ɍ������Ȃ����I")
            end
          else
            action.push("�̂킫�̉������r�߂Ă����I")
            action.push("�̎�؂ɂӂ����Ƒ��𐁂��������I")
            action.push("�̋��Ɏw�𔇂킹�Ă����I")
            action.push("�̍������킳��ƕ��łĂ����I")
            action.push("�̑����������킳��ƕ��łĂ����I")
          end
          action = action[rand(action.size)]
          m = "#{speaker}�͖��������܂܁A\m\n#{master}#{action}"
        end
      #--------------------------------------------------------------------------
      end
    #==============================================================================
    # �������E�ʏ�
    #==============================================================================
    when "�����E�ʏ�"
      m = "#{speaker}�͔��΂ނƁA\m\n#{master}�̃y�j�X���������Ă����I"
      case $msg.at_type
      #--------------------------------------------------------------------------
      when "��"
        #����_��˂���
        if $game_actors[101].critical == true
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�͔������y���ނ��̂悤�ɁA\m\n#{master}�̃y�j�X�����������w�ŘM�ԁI"
              m = "#{speaker}�͈������ނ��̂悤�ɁA\m\n#{master}�̃y�j�X�����������w�ŘM�ԁI" if $msg.t_enemy.love > 0
            else
              m = "#{speaker}�͐S�����w�J���ŁA\m\n#{master}�̃y�j�X���Ԓf�Ȃ��U�ߗ��ĂĂ����I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�͊Ԓf�Ȃ��A\m\n#{master}�̃y�j�X�̕q���ȕ������U�߂Ă����I"
            else
              m = "#{speaker}�͎w�𗍂߂āA\m\n#{master}�̃y�j�X�̕q���ȕ������U�߂Ă����I"
            end
          end
        else
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�͊Ԓf�Ȃ��A\m\n#{master}�̃y�j�X���w�ōU�ߗ��Ă�I"
            else
              m = "#{speaker}�͎w�𗍂߂āA\m\n#{master}�̃y�j�X���������グ�Ă����I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�́A\m\n#{master}�̃y�j�X�Ɏw�𗍂߈������Ă����I"
            else
              m = "#{speaker}�͎�ŁA\m\n#{master}�̃y�j�X���������Ă����I"
            end
          end
        end
      #--------------------------------------------------------------------------
      when "��"
        #����_��˂���
        if $game_actors[101].critical == true
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�͔������y���ނ��̂悤�ɁA\m\n#{master}�̃y�j�X�����������r�ߏグ�Ă����I"
              m = "#{speaker}�͈������ނ��̂悤�ɁA\m\n#{master}�̃y�j�X�����������r�ߏグ�Ă����I" if $msg.t_enemy.love > 0
            else
              m = "#{speaker}�͐S������g���ŁA\m\n#{master}�̃y�j�X���Ԓf�Ȃ��r�߉񂵂Ă����I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�͊Ԓf�Ȃ��A\m\n#{master}�̃y�j�X�̕q���ȕ������r�ߑ������I"
            else
              m = "#{speaker}�͐��ŁA\m\n#{master}�̃y�j�X�̕q���ȕ������r�ߏグ���I"
            end
          end
        else
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�͊Ԓf�Ȃ��A\m\n#{master}�̃y�j�X��O�O���r�ߏグ�Ă����I"
            else
              m = "#{speaker}�͐��ŁA\m\n#{master}�̃y�j�X���ł炷�悤���r�ߏグ���I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�͋x�ނ��ƂȂ��A\m\n#{master}�̃y�j�X��O�O���r�ߏグ�Ă����I"
            else
              m = "#{speaker}�͐�ŁA\m\n#{master}�̃y�j�X���r�ߏグ�Ă����I"
            end
          end
        end
      #--------------------------------------------------------------------------
      when "��"
        #����_��˂���
        if $game_actors[101].critical == true
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�͔������y���ނ��̂悤�ɁA\m\n#{master}�̃y�j�X�𗼑��̗��ł������Ă����I"
              m = "#{speaker}�͈������ނ��̂悤�ɁA\m\n#{master}�̃y�j�X�𗼑��̗��ł������Ă����I" if $msg.t_enemy.love > 0
            else
              m = "#{speaker}�͐S���Ă���ƌ����΂���ɁA\m\n#{master}�̃y�j�X�𑫗��ŝs�ˉ񂵂Ă����I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�͋x�ނ��ƂȂ��A\m\n#{master}�̃y�j�X�𑫗��ŝs�ˉ񂵂Ă����I"
            else
              m = "#{speaker}�͑��̗��ŁA\m\n#{master}�̃y�j�X�̕q���ȕ������������Ă����I"
            end
          end
        else
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�͊ɋ}�����Ȃ���A\m\n#{master}�̃y�j�X�𑫂̎w�ōX�ɘM�ԁI"
            else
              m = "#{speaker}�͑��̎w�ŁA\m\n#{master}�̃y�j�X���ł炷�悤�ɘM��ł����I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�͊ɋ}�����Ȃ���A\m\n#{master}�̃y�j�X�𑫗��ł������Ă����I"
            else
              m = "#{speaker}�͑��̗��ŁA\m\n#{master}�̃y�j�X���y�����݂����I"
            end
          end
        end
      #--------------------------------------------------------------------------
      when "��"
        if $msg.chain_attack == true
          m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X���Ԓf�Ȃ��������Ă����I"
          m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɎC��t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
        else
          m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X�����݂������Ă����I"
          m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɉ����t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
        end
        #����_��˂���
        if $game_actors[101].critical == true
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
                m = "#{speaker}�͔������y���ނ��̂悤�ɁA\m\n#{$msg.t_enemy.bustsize}���y�j�X�ɎC��t���Ă����I"
                m = "#{speaker}�͈������ނ��̂悤�ɁA\m\n#{$msg.t_enemy.bustsize}���y�j�X�ɎC��t���Ă����I" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}�͔������y���ނ��̂悤�ɁA\m\n#{$msg.t_enemy.bustsize}�Ńy�j�X�����������������Ă����I"
                m = "#{speaker}�͈������ނ��̂悤�ɁA\m\n#{$msg.t_enemy.bustsize}�Ńy�j�X�����������������Ă����I" if $msg.t_enemy.love > 0
              end
            else
              m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X�����݂������Ă����I"
              m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɉ����t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X���Ԓf�Ȃ��������Ă����I"
              m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɎC��t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            else
              m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X�����݂������Ă����I"
              m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɉ����t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            end
          end
        else
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X���Ԓf�Ȃ��������Ă����I"
              m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɎC��t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            else
              m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X�����݂������Ă����I"
              m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɉ����t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X���Ԓf�Ȃ��������Ă����I"
              m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɎC��t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            else
              m = "#{speaker}��#{$msg.t_enemy.bustsize}�ŁA\m\n#{master}�̃y�j�X�����݂������Ă����I"
              m = "#{speaker}��#{$msg.t_enemy.bustsize}���A\m\n#{master}�̃y�j�X�ɉ����t���Ă����I" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            end
          end
        end
      #--------------------------------------------------------------------------
      when "��"
        #����_��˂���
        if $game_actors[101].critical == true
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "As if enjoying his reaction, #{speaker}\m\n continues to bounce up and do��n #{master}'s penis!"
              m = "#{speaker} continues to lovingly bounce\m\n up and do��n #{master}'s penis!" if $msg.t_enemy.love > 0
            else
              m = "Having found his ��eakness, #{speaker} grinds\m\n her pussy do��n on #{master}'s penis!"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker} continues grinding her hips\m\n back and forth on #{master}'s penis!"
            else
              m = "#{speaker} rubs her pussy on #{master},\m\n vigorously inciting response fro�� his penis!"
            end
          end
        else
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker} continues bouncing ��ildly\m\n on #{master}'s penis!"
            else
              m = "#{speaker} rubs her pussy against\m\n #{master}'s penis!"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker} continues bouncing ��ildly\m\n on #{master}'s penis!"
            else
              m = "#{speaker} rubs her pussy against\m\n #{master}'s penis!"
            end
          end
        end
      #--------------------------------------------------------------------------
      when "�K��"
        #����_��˂���
        if $game_actors[101].critical == true
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�͔������y���ނ��̂悤�ɁA\m\n#{master}�̃y�j�X��K���ł������Ă����I"
              m = "#{speaker}�͈������ނ��̂悤�ɁA\m\n#{master}�̃y�j�X��K���ł������Ă����I" if $msg.t_enemy.love > 0
            else
              m = "#{speaker}�͊��ꂽ���g���ŁA\m\n#{master}�̃y�j�X��K���ŘM��ł����I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�͐K�������˂点�A\m\n#{master}�̃y�j�X���Ԓf�Ȃ��������グ�Ă����I"
            else
              m = "#{speaker}�͐K�����I�݂Ɏg���A\m\n#{master}�̃y�j�X���������グ�Ă����I"
            end
          end
        else
          case @weakpoints
          when 20,10
            if $msg.chain_attack == true
              m = "#{speaker}�̓��Y�~�J���ɁA\m\n�K����#{master}�̃y�j�X���������グ�Ă����I"
            else
              m = "#{speaker}�͎����̐K�����A\m\n#{master}�̃y�j�X�Ɋ����t���Ă����I"
            end
          else
            if $msg.chain_attack == true
              m = "#{speaker}�̓��Y�~�J���ɁA\m\n�K����#{master}�̃y�j�X���������グ�Ă����I"
            else
              m = "#{speaker}�͎����̐K�����A\m\n#{master}�̃y�j�X�Ɋ����t���Ă����I"
            end
          end
        end
      #--------------------------------------------------------------------------
      end
    #==============================================================================
    # ������
    #==============================================================================
    when "����"
      case $msg.at_type
      when "���}��"
        case $msg.talk_step
        when 2 #�}�����
          m = "Having invited #{master}, #{speaker} ��uickly\m\n stabs his penis into her pussy before he can escape!"
        when 77 #�}������
          m = "#{master} hardens his resolve to resist her invitation!"
        end
#      when "���}��"
#      when "�K�}��"
#      when "�p�C�Y��"
#      when "�L�b�X"
      end
    end
    #============================================================================
    return if m == ""
    $game_temp.battle_log_text += m
  end

###############################################################################  
  #============================================================================
  # ���g�[�N���̃e�L�X�g�ݒ�(����\���O�̃e�L�X�g)
  #============================================================================
  def make_text_pretalk
    speaker = $msg.t_enemy.name #��b���̃G�l�~�[��
    master = $game_actors[101].name #��l����
    #���݂���Ȃ�A�p�[�g�i�[��
    if $msg.t_partner != nil
      servant = $msg.t_partner.name
    else
      servant = nil
    end
    m = ""
    case $msg.tag
    #==============================================================================
    # ����l���E��
    #==============================================================================
    when "��l���E��"
      m = "#{speaker} leans on #{master}'s chest,\m\n gazing deeply into his eyes...!"
      m = "#{speaker} leans on #{master}, taking fleeting\m\n glances at hi�� ��hile t��irling her finger on his chest!" if $msg.t_enemy.negative?
    #==============================================================================
    # �����ԒE��
    #==============================================================================
    when "���ԒE��"
      m = "#{speaker} gazes at #{servant}\m\n ��ith a suggestive look on her face...!"
      m = "#{speaker} stares at #{servant}\m\n ��ith an insinuating look on her face...!" if $msg.t_enemy.negative?
    #==============================================================================
    # �������E��
    #==============================================================================
    when "�����E��"
      m = "#{speaker} begins peeling back her clothes,\m\n turning to��ards #{master} ��ith a lustful expression!"
      m = "#{speaker} begins peeling back her clothes,\m\n eyeing #{master} ��ith suggestive intent!" if $msg.t_enemy.negative?
      m = "#{speaker} shakes the jiggling sli��e covering\m\n her body in front of #{master}'s eyes....!" if $msg.t_enemy.tribe_slime?
    #==============================================================================
    # ���z���E��
    #==============================================================================
    when "�z���E��"
      m = "#{speaker} closes her eyes,\m\n bringing her face close to #{master}'s lips...!"
      m = "#{speaker} s��iles,\m\n bringing her face close to #{master}'s lips...!" if $msg.t_enemy.positive?
    #==============================================================================
    # ���z���E����
    #==============================================================================
    when "�z���E����"
      m = "#{speaker} closes her eyes,\m\n bringing her face close to #{master}'s crotch...!"
      m = "#{speaker} s��iles,\m\n bringing her face close to #{master}'s crotch...!" if $msg.t_enemy.positive?
    #==============================================================================
    # ������
    #==============================================================================
    when "����"
      emotion = ""
      case $msg.t_enemy.personality
      when "�D�F","����"
        emotion = "s��iles suggestively"
      when "�z�C","�_�a","�����C"
        emotion = "s��iles ��ischievously"
      when "����","�Â���"
        emotion = "coyly glances in and out of eye contact"
      when "���C"
        emotion = "shyly turns her face the other ��ay"
      when "�Ӓn��"
        emotion = "grins provacatively"
      when "�s�v�c","��i","�|��"
        emotion = "s��iles mysteriously"
      when "�W��","�]��"
        emotion = "blushes slightly"
      when "�V�R"
        emotion = "looks ��ith a sleepy expression"
      else
        emotion = "stands on full display"
      end
      #�e�L�X�g���`(���A�K�n�͌��݂͕���̂��߁A�����ʂɊ���U��)
      case $msg.at_parts
      #�������Ŏ���
      when "�ΏہF��","�ΏہF��"
        m = "#{speaker} #{emotion},\m\n tracing her #{$msg.t_enemy.bustsize} ��ith her finger!"
      #�A�\�R�Ɏw����Ŏ���
      when "�ΏہF�A�\�R","�ΏہF�K"
        m = "#{speaker} #{emotion},\m\n tracing a finger do��n to her crotch!"
      #�A�j��M���Ď���
      when "�ΏہF�A�j","�ΏہF�A�i��"
        m = "#{speaker} #{emotion},\m\n tracing her finger around her clit!"
      end
    #==============================================================================
    # ����d
    #==============================================================================
    when "��d"
      #�e�L�X�g���`
      case $msg.at_parts
      #�L�b�X�ŕ�d
      when "�ΏہF��"
        m = "#{speaker} closes her eyes,\m\n offering #{master} her lips!"
      #�������ɕ�d
      when "�ΏہF��"
        m = "#{speaker} clings tightly to #{master},\m\n pressing her #{$msg.t_enemy.bustsize} against his ar��!"
      #�A�\�R�ɕ�d
      when "�ΏہF�A�\�R","�ΏہF�A�i��"
        m = "#{speaker} approaches #{master}\n\m and spreads open her pussy ��ith her fingers!"
        m = "��ith her fingers, #{speaker} bashfully spreads\m\n open her inti��ates!" if $msg.t_enemy.negative?
      #�A�j�ɕ�d
      when "�ΏہF�A�j"
        m = "#{speaker} approaches #{master}\n\m and spreads open her pussy ��ith her fingers!"
        m = "��ith her fingers, #{speaker} bashfully spreads\m\n open her inti��ates!" if $msg.t_enemy.negative?
      #���K�ɕ�d
      when "�ΏہF�K"
        m = "Face do��n, #{speaker} kneels over before #{master},\m\n and ��aves her butt in front of his face!"
        m = "Face do��n,#{speaker} shyly kneels over,\m\n ��aving her rear in front of #{master}!" if $msg.t_enemy.negative?
      #�A�i���ɕ�d
#      when "�ΏہF�A�i��"
#        m = "#{master}��#{action}�A\m\n#{speaker}�̋e�����w�ň��������I"
#        m = "#{master}��#{action}�A\m\n#{speaker}�̋e���ɐ�𔇂킹���I" if $game_variables[17] > 50 
      end
    #==============================================================================
    # �������E�ʏ�
    #==============================================================================
    when "�����E�ʏ�"
      emotion = ""
      case $msg.t_enemy.personality
      when "�����C","����","�Ӓn��"
        emotion = "licks her lips"
      when "��i","�_�a"
        emotion = "softly s��iles"
      when "�W��","����"
        emotion = "glances fleetingly"
      when "���C","�]��","�|��"
        emotion = "looks ��ith feverish eyes"
      when "�s�v�c","�V�R"
        emotion = "bears an ad��iring look"
      when "�z�C","�Â���"
        emotion = "s��iles ��ischievously"
      else #�D�F
        emotion = "s��iles suggestively"
      end
      m = "#{speaker} #{emotion} as she gazes\m\n do��n at #{master}'s crotch!"
    #==============================================================================
    # �������E�ʏ�
    #==============================================================================
    when "�����E����"
      emotion = ""
      case $msg.t_enemy.personality
      when "�����C","����","�Ӓn��"
        emotion = "licks her lips"
      when "��i","�_�a"
        emotion = "softly s��iles"
      when "�W��","����"
        emotion = "looks ��ith feverish eyes"
      when "���C","�]��","�|��"
        emotion = "stares ��ith longing eyes"
      when "�s�v�c","�V�R"
        emotion = "bears a carefree s��ile"
      when "�z�C","�Â���"
        emotion = "s��iles ��ischievously"
      else #�D�F
        emotion = "s��iles suggestively"
      end
      action = []
      case $msg.at_parts
      #���C���T�[�g�E�A�N�Z�v�g
      #--------------------------------------------------------------------------
      when "���}���F�A�\�R��","�K�}���F�K��"
        action.push("turning her backside to��ards #{master}")
        action.push("looking do��n at #{master}") if $msg.t_enemy.initiative_level > 0
      when "���}���F����","�p�C�Y��"
        action.push("looking up at #{master}")
        action.push("toying around ��ith #{master}'s penis") if $msg.t_enemy.initiative_level > 0
      when "�w�ʍS��"
        action.push("holding #{master} do��n even ��ore")
      else
        action.push("holding #{master} do��n even ��ore")
      end
      action = action[rand(action.size)]
      m = "#{speaker} #{emotion},\m\n #{action}!"
    #==============================================================================
    # ������
    #==============================================================================
    when "����"
      case $msg.t_enemy.personality
      when "�D�F"
        m = "#{speaker} teases open her pussy,\m\n smiling pro��iscuously as she beckons #{master}!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n reaching back to spread her pussy te��ptingly!" if $game_variables[17] > 50 #��
      when "��i"
        m = "As if to te��pt hi��, #{speaker}\n\m spreads her legs and beckons #{master} ��ith her finger!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n seductively gazing into #{master}'s eyes!" if $game_variables[17] > 50 #��
      when "����"
        m = "#{speaker} teases open her pussy,\m\n smiling at #{master} ��ith a procative gaze!" #�O
        m = "#{speaker} thrusts out her ass,\m\n thro��ing #{master} a daring smile!" if $game_variables[17] > 50 #��
      when "�W��"
        m = "#{speaker} blushes shyly,\m\n opening up her legs for #{master} to see!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n giving #{master} a ��elcoming gaze!" if $game_variables[17] > 50 #��
      when "�_�a"
        m = "As if to te��pt hi��, #{speaker}\n\m spreads her legs and beckons #{master} ��ith her finger!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n reaching back to spread her pussy te��ptingly!" if $game_variables[17] > 50 #��
      when "�����C"
        m = "#{speaker} boldly spreads her legs apart,\m\n casting a provoking gaze at #{master}!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n thro��ing #{master} a fearless smile!" if $game_variables[17] > 50 #��
      when "���C"
        m = "Covering her face ��ith her hands,\m\n #{speaker} opens her legs for #{master} to see!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n sha��efully turns her butt to��ards #{master}!" if $game_variables[17] > 50 #��
      when "�z�C"
        m = "#{speaker} boldly spreads her legs apart�A\m\n staring at #{master} ��ith expectant eyes!" #�O
        m = "#{speaker} thrusts out her ass,\m\n staring at #{master} ��ith expectant eyes!" if $game_variables[17] > 50 #��
      when "�Ӓn��"
        m = "As if to te��pt hi��, #{speaker}\n\m spreads her legs and beckons #{master} ��ith her finger!" #�O
        m = "#{speaker} cra��ls do��n on all fours, \m\n reaching back to spread her pussy te��ptingly!" if $game_variables[17] > 50 #��
      when "�V�R"
        m = "#{speaker} looks expectantly at #{master}\m\n as she spreads open her legs!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n staring at #{master} ��ith longing eyes!" if $game_variables[17] > 50 #��
      when "�]��"
        m = "#{speaker} boldly spreads her legs apart,\m\n looking obediently at #{master}!" #�O
        m = "#{speaker} thrusts out her ass,\m\n staring at #{master} ��ith longing eyes!" if $game_variables[17] > 50 #��
      when "����"
        m = "#{speaker} doggedly spreads open her legs,\m\n and shoots a provoking gaze at #{master}!" #�O
        m = "#{speaker} thrusts out her ass,\m\n and looks at #{master} ��ith a challenging expression!" if $game_variables[17] > 50 #��
      when "�|��"
        m = "#{speaker} teases open her pussy,\m\n thro��ing #{master} a be��itching smile!" #�O
        m = "#{speaker} cra��ls do��n on all fours�A\m\n staring at #{master} ��ith longing eyes!" if $game_variables[17] > 50 #��
      when "�Â���"
        m = "#{speaker} looks expectantly, \m\n ��atching #{master} as she spreads her legs!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n staring at #{master} ��ith longing eyes!" if $game_variables[17] > 50 #��
      when "�s�v�c"
        m = "#{speaker} slo��ly opens up her legs, ��atching \m\n #{master} as she lifts up her pelvis!" #�O
        m = "#{speaker} thrusts out her ass,\m\n looking back at #{master}!" if $game_variables[17] > 50 #��
      when "�ƑP"
        m = "#{speaker} opens her legs for display,\m\n thro��ing #{master} a be��itching smile!" #�O
        m = "#{speaker} cra��ls do��n on all fours,\m\n arching her ass high as if to provoke #{master}!" if $game_variables[17] > 50 #��
      end
    end
   #============================================================================
    return if m == ""
    $game_temp.battle_log_text += m
  end
###############################################################################  
end