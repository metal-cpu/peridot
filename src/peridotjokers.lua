--- Needed for TALISMAN
to_big = to_big or function(num)
    return num
end

--- JokerDisplay compatibility (WIP)
if JokerDisplay then
    -- SMODS.load_file("src/peridot_jokerdisplay_definitions.lua")()
end

---- COMMON JOKERS ----

-- Common Joker 1/7
-- Pi
SMODS.Joker {
    key = "j_pi",
    config = {
        extra = {
            mult314 = 3,
            chips314 = 14
        }
    },
    loc_txt = {
        ['name'] = 'Pi',
        ['text'] = {
            'Each played',
            '{C:attention}Ace{}, {C:attention}3{}, or {C:attention}4{} gives',
            '{C:mult}+3{} Mult and {C:blue}+14{} Chips',
            'when scored'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 0, y = 0 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 3 or context.other_card:get_id() == 4 or context.other_card:get_id() == 14 then
                return {
                    mult = card.ability.extra.mult314,
                    chips = card.ability.extra.chips314
                }
            end    
         end
    end
}

-- Common Joker 2/7
-- Monument
SMODS.Joker {
    key = "j_monument",
    config = { 
      extra = { 
        chips = 0 
              } 
      },

    loc_txt = {
        ['name'] = 'Monument',
        ['text'] = {
            'Adds 10x the sell value',
            'of all other owned',
            '{C:attention}Jokers{} to Chips',
            '{C:inactive}(Currently {C:blue}+#1#{C:inactive} Chips)'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 1, y = 0 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    -- Loc function for dynamic text
    loc_vars = function(self, info_queue, card)
          local sell_val = 0
            if G.jokers ~= nil then
                for i = 1, #G.jokers.cards do
                    -- Check if it's not THIS monument
                    if G.jokers.cards[i] ~= card then
                        sell_val = sell_val + G.jokers.cards[i].sell_cost
                    end
                end
                
                if sell_val > 0 then
                    local tenx_sell_val = sell_val * 10
                    card.ability.extra.chips = tenx_sell_val
                end
            end
              
        return { vars = { card.ability.extra.chips } }
    end,
    
    calculate = function(self, card, context)
        if (context.joker_main or not context.joker_main) then
            local sell_val = 0
            for i = 1, #G.jokers.cards do
                -- Check if it's not THIS monument
                if G.jokers.cards[i] ~= card then
                    sell_val = sell_val + G.jokers.cards[i].sell_cost
                end
            end
            
            if sell_val > 0 then
                local tenx_sell_val = sell_val * 10
                card.ability.extra.chips = tenx_sell_val
                
                if context.joker_main then
                    return {
                            chips = card.ability.extra.chips,
                            colour = G.C.CHIPS
                    }
                end
            end
        end
    end
}

-- Common Joker 3/7
-- Coin Ship
SMODS.Joker {
    key = "j_coinship",
    config = {
        extra = {
            dollar = 1
        }
    },
    loc_txt = {
        ['name'] = 'Coin Ship',
        ['text'] = {
            {
                'Earn {C:money}$#1#{} every',
                'played hand',
            }
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 2, y = 0 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollar } }
    end,

    calculate = function(self, card, context)
      if context.before then
        return { dollars = card.ability.extra.dollar }
      end
    end
}

-- Common Joker 4/7
-- Tangent Line
SMODS.Joker {
    key = "j_tangentline",
    config = {
        extra = {
            chips = 5,
            prev_hand = 'High Card',
            chips_gain = 0
        }
    },
    loc_txt = {
        ['name'] = 'Tangent Line',
        ['text'] = {
            'Gains {C:blue}+#1#{} Chips if',
            'next played {C:attention}poker hand{}',
            'is not a {C:attention}#2#{}',
            '{C:inactive}(Currently {C:blue}+#3#{C:inactive} Chips)'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 3, y = 0 },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
      if SMODS.last_hand ~= nil then
            card.ability.extra.prev_hand = SMODS.last_hand.scoring_name
      end
      return { vars = { card.ability.extra.chips, card.ability.extra.prev_hand, card.ability.extra.chips_gain } }
    end,

    calculate = function(self, card, context)
        if context.before then
          if context.scoring_name == card.ability.extra.prev_hand then
            -- do not increment chips
            card.ability.extra.chips_gain = card.ability.extra.chips_gain
          else
            -- increment chips
            card.ability.extra.chips_gain = card.ability.extra.chips_gain + card.ability.extra.chips
            return { message = 'Upgrade!', colour = G.C.CHIPS }
          end
        end
        if context.joker_main then
          return { chips = card.ability.extra.chips_gain }
        end
    end
}

-- Common Joker 5/7
-- Virtual Joker
SMODS.Joker {
    key = "j_virtualjoker",
    config = {
        extra = {
            card = 5,
            chips = 25,
            mult = 5
        }
    },
    loc_txt = {
        ['name'] = 'Virtual Joker',
        ['text'] = {
          'Each {C:attention}#1#{} held in hand',
          'gives {C:blue}+#2#{} Chips',
          'and {C:mult}+5{} Mult'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 4, y = 0 },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.card, card.ability.extra.chips, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 5 then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    mult = 5
                }
            end
        end
    end,
}

-- Common Joker 6/7
-- Sawtooth Wave (WIP)
SMODS.Joker {
    key = "j_sawtoothwave",
    config = {
        extra = {
            mult = 4,
            rank = '2',
            id = 2,
            hands_played = 0,
            initialize = false
        }
    },
    loc_txt = {
        ['name'] = 'Sawtooth Wave',
        ['text'] = {
            '{C:mult}+#1#{} Mult per scored {C:attention}#2#{}',
            '{s:0.8}Rank increments every hand{}',
            '{s:0.8}Resets after highest rank{}'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 5, y = 0 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
      local rank_table = { 'none', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }
      local current_cards = {}
      local rank_found = false
      
      if not card.ability.initialize and G.playing_cards then
        card.ability.initialize = true
        
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
              table.insert(current_cards, playing_card.base.id)
            end
        end

        while not rank_found do
          for i = 1, #current_cards do
            if current_cards[i] == card.ability.extra.id then
              rank_found = true
              break
            end
          end
          if not rank_found then
            if card.ability.extra.id >= 14 then
               card.ability.extra.id = 2
            else
               card.ability.extra.id = card.ability.extra.id + 1
            end
          end
        end
        card.ability.extra.rank = rank_table[card.ability.extra.id]
      end
        
      return { vars = { card.ability.extra.mult, card.ability.extra.rank, card.ability.extra.id, 
          card.ability.extra.hands_played, card.ability.extra.initialize } }
    end,

    calculate = function(self, card, context)
        local idlocal = card.ability.extra.id
        local hands_played = G.GAME.hands_played -- initial value
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == idlocal then
                return { mult = card.ability.extra.mult }
            end
        end
        if context.after and G.GAME.hands_played ~= card.ability.extra.hands_played then
          local rank_table = { 'none', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }
          local current_cards = {}
          local rank_found = false
          
          if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                  table.insert(current_cards, playing_card.base.id)
                end
            end

            if card.ability.extra.id >= 14 then
               card.ability.extra.id = 2
            else
               card.ability.extra.id = card.ability.extra.id + 1
            end

            while not rank_found do
              for i = 1, #current_cards do
                if current_cards[i] == card.ability.extra.id then
                  rank_found = true
                  break
                end
              end
              if not rank_found then
                if card.ability.extra.id >= 14 then
                   card.ability.extra.id = 2
                else
                   card.ability.extra.id = card.ability.extra.id + 1
                end
              end
            end
            card.ability.extra.rank = rank_table[card.ability.extra.id]
          end
        end
    end
}

-- Common Joker 7/7
-- Ferris Wheel
SMODS.Joker {
    key = "j_ferriswheel",
    config = {
        extra = {
            mult_gain = 1,
            mult = 0,
            facecard = 'Jack',
            id = 11,
            initialize = false
        }
    },
    loc_txt = {
        ['name'] = 'Ferris Wheel',
        ['text'] = {
                    'Gains {C:mult}+#1#{} Mult per hand',
                    'played with a scoring {C:attention}#3#{}',
                    '{s:0.8}Face card changes every round{}',
                    '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
        },
        ['unlock'] = {
            ''
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    display_size = {
        w = 71 * 1,
        h = 95 * 1
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
      local valid_faces = {}
      if not card.ability.initialize and G.playing_cards then
        card.ability.initialize = true
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
              if playing_card:is_face() then
                table.insert(valid_faces, playing_card)
              end                
            end
        end
        
        local fw_card = pseudorandom_element(valid_faces, 'peridot_ferriswheel')
        if fw_card then
            card.ability.extra.facecard = fw_card.base.value
            card.ability.extra.id = fw_card.base.id
        else
            card.ability.extra.facecard = 'Jack'
            card.ability.extra.id = 11              
        end
      else
      end
      return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult, card.ability.extra.facecard, card.ability.extra.id, card.ability.extra.initialize } }
    end,
    
    calculate = function(self, card, context)
        local valid_face_found = false
        if context.before and not context.blueprint and not context.debuffed_hand then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == card.ability.extra.id then
                    valid_face_found = true
                    break
                end
            end
            if valid_face_found then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round then
          card.ability.extra.initialize = true
          local valid_faces = {}
            if G.playing_cards then
              for _, playing_card in ipairs(G.playing_cards) do
                  if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                    if playing_card:is_face() then
                      table.insert(valid_faces, playing_card)
                    end                
                  end
              end
              
              local fw_card = pseudorandom_element(valid_faces, 'peridot_ferriswheel')
              if fw_card then
                  card.ability.extra.facecard = fw_card.base.value
                  card.ability.extra.id = fw_card.base.id
              else
                  card.ability.extra.facecard = 'Jack'
                  card.ability.extra.id = 11              
              end
              
            else
            end
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult, card.ability.extra.facecard, card.ability.extra.id } }
        end
    end
}

-- Uncommon Joker 1/7
-- Lightning
SMODS.Joker {
    key = "j_lightning",
    config = {
        extra = { 
          rank = 'Ace',
          id = 14,
          xmult = 2,
          initialize = false }
    },
    loc_txt = {
        ['name'] = 'Lightning',
        ['text'] = {
            'First played {C:attention}#1#{} gives',
            '{X:red,C:white}X#3#{} Mult when scored',
            '{s:0.8}Rank changes every round{}'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 7, y = 0 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
      
      if not card.ability.extra.initialize then
        card.ability.extra.initialize = true
        local valid_ranks = {}
        if G.playing_cards then
          for _, playing_card in ipairs(G.playing_cards) do
              if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                table.insert(valid_ranks, playing_card)
              end
          end
          local th_card = pseudorandom_element(valid_ranks, 'peridot_lightning')
          if th_card then
              card.ability.extra.rank = th_card.base.value
              card.ability.extra.id = th_card.base.id
          end
        else
        end
      end      
      
        return { vars = { card.ability.extra.rank, card.ability.extra.id, card.ability.extra.xmult, 
            card.ability.extra.initialize } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == card.ability.extra.id then
            local is_first = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == card.ability.extra.id then
                    is_first = context.scoring_hand[i] == context.other_card
                    break
                end
            end
            if is_first then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
        
        if context.end_of_round then
          local valid_ranks = {}
          for _, playing_card in ipairs(G.playing_cards) do
              if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                table.insert(valid_ranks, playing_card)
              end
          end
          local th_card = pseudorandom_element(valid_ranks, 'peridot_lightning')
          if th_card then
              card.ability.extra.rank = th_card.base.value
              card.ability.extra.id = th_card.base.id
          end          
        end
    end
}

-- Uncommon Joker 2/7
-- Slot Machine
SMODS.Joker {
    key = "j_slotmachine",

    loc_txt = {
        ['name'] = 'Slot Machine',
        ['text'] = {
              "{C:green}#1# in #2#{} chance for each",
              "played {C:attention}7{} to create a",
              "random {C:attention}consumable{}",
              "when scored",
              "{C:inactive}(Must have room)",
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 8, y = 0 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',
   config = { 
     extra = {
       odds = 4
 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'peridot_slotmachine')
        return { 
          vars = { 
            numerator, denominator
            } }
    end,
    calculate = function(self, card, context)
       local cons_table = {'Planet', 'Planet', 'Planet', 'Tarot', 'Tarot', 'Tarot', 'Spectral'}
       if context.individual and context.cardarea == G.play and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if (context.other_card:get_id() == 7) and SMODS.pseudorandom_probability(card, 'peridot_slotmachine', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                local chosen_cons = pseudorandom_element(cons_table, 'peridot_slotmachine')
                local loc_message = ''
                if chosen_cons == 'Spectral' then loc_message = 'k_plus_spectral'
                elseif chosen_cons == 'Tarot' then loc_message = 'k_plus_tarot'
                elseif chosen_cons == 'Planet' then loc_message = 'k_plus_planet'
                else
                end
                
                return {
                    extra = {
                        message = localize(loc_message),
                        message_card = card,
                        no_juice = true,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = chosen_cons,
                                        soulable = true
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    },
                }
            end
        end
    end
}

-- Uncommon Joker 3/7
-- Redline
SMODS.Joker {
    key = "j_redline",
    config = {
        extra = {
            chips = 9,
            mult = 9
        }
    },
    loc_txt = {
        ['name'] = 'Redline',
        ['text'] = {
            'Each played {C:attention}8{} or {C:attention}9{}',
            'gives {C:blue}+#1#{} Chips',
            'and {C:mult}+#2#{} Mult',
            'when scored'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    display_size = {
        w = 71 * 1,
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,


    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 8 or context.other_card:get_id() == 9 then
                return {
                    mult = card.ability.extra.mult,
                    chips = card.ability.extra.chips
                }
            end    
         end
    end
}

-- Uncommon Joker 4/7
-- Peridot
SMODS.Joker {
    key = "j_peridot",
    config = {
        extra = {
            xmult = 1.5
        }
    },
    loc_txt = {
        ['name'] = 'Peridot',
        ['text'] = {
            'Each played {C:attention}6{} or {C:attention}7{} gives',
            '{X:red,C:white}X1.5{} Mult when scored'
        },
        ['unlock'] = {
            'Unlocked by default.'
        }
    },
    pos = { x = 0, y = 1 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 6 or context.other_card:get_id() == 7 then
                return {
                    xmult = card.ability.extra.xmult
                }
            end    
         end
    end
}

-- Uncommon Joker 5/7
-- Standing Ovation
SMODS.Joker {
    key = "j_standingovation",
    config = {
        extra = {
            suit = 'Spades',
            initialize = false
        }
    },
    loc_txt = {
        ['name'] = 'Standing Ovation',
        ['text'] = {
            'Retrigger all',
            'played {V:1}#1#{}',
            '{s:0.8}Suit changes every round{}'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 1, y = 1 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    -- Display current suit in text
    loc_vars = function(self, info_queue, card)
      local suitcolor = G.C.SUITS.Spades
      if not card.ability.extra.initialize then
        card.ability.extra.initialize = true
        
        local valid_suits = {}
        if G.playing_cards then
          for _, playing_card in ipairs(G.playing_cards) do
              if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                table.insert(valid_suits, playing_card.base.suit)
              end
          end
          local so_suit = pseudorandom_element(valid_suits, 'peridot_standingovation')
          if so_suit then
              card.ability.extra.suit = so_suit
          else
              card.ability.extra.suit = 'Spades'
          end
        else
        end        
      end

      if card.ability.extra.suit == 'Spades'       then suitcolor = G.C.SUITS.Spades
      elseif card.ability.extra.suit == 'Hearts'   then suitcolor = G.C.SUITS.Hearts
      elseif card.ability.extra.suit == 'Clubs'    then suitcolor = G.C.SUITS.Clubs
      elseif card.ability.extra.suit == 'Diamonds' then suitcolor = G.C.SUITS.Diamonds
      end      
      return { vars = { card.ability.extra.suit, card.ability.extra.initialize,         
          colours = { suitcolor } } }
    end,

    -- Retrigger Logic
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            local suit = card.ability.extra.suit
            if context.other_card:is_suit(suit) then
                return {
                    message = 'Again!',
                    repetitions = 1,
                    card = card
                }
            end
        end
        if context.end_of_round then
          local valid_suits = {}
          if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                  table.insert(valid_suits, playing_card.base.suit)
                end
            end
            local so_suit = pseudorandom_element(valid_suits, 'peridot_standingovation')
            if so_suit then
                card.ability.extra.suit = so_suit
            else
                card.ability.extra.suit = 'Spades'
            end
          else
          end           
        end
    end
}

-- Uncommon Joker 6/7
-- Dart Board
SMODS.Joker {
    key = "j_dartboard",
    config = {
        extra = {
            value = 4
        }
    },
    loc_txt = {
        ['name'] = 'Dart Board',
        ['text'] = {
            'Earn {C:money}$#1#{} when',
            'a playing card',
            'is {C:red}destroyed{}'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 2, y = 1 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.value } }
    end,
    
    calculate = function(self, card, context)
      local dollars_sum = 0
      if context.removed and not context.debuffed_hand then
        for k, v in ipairs(context.removed) do
        end
        return { dollars = #context.removed * card.ability.extra.value }
      end
    end
}

-- Uncommon Joker 7/7
-- Rising Tide
SMODS.Joker {
    key = "j_risingtide",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Rising Tide',
        ['text'] = {
          'Adds the number of times',
          '{C:attention}the most played poker hand{}',
          'has been played this run to Mult'
        },
        ['unlock'] = {
            'Unlocked by default.'
        }
    },
    pos = { x = 3, y = 1 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    calculate = function(self, card, context)
      local most_played = 0
      if context.joker_main then
        for k, v in pairs(G.GAME.hands) do
          if v.played > most_played then
            most_played = v.played
          end
        end
        if most_played > 0 then
          return {
              mult = most_played
          }
        end
      end
    end
}


-- Rare Joker 1/7
-- Afterimage
SMODS.Joker {
    key = "j_afterimage",
    config = {
        extra = {
            h_plays = -1
        }
    },
    loc_txt = {
        ['name'] = 'Afterimage',
        ['text'] = {
          'Creates a {C:dark_edition}Negative{} {C:tarot}Fool{} card',
          'when {C:attention}Blind{} is selected,',
          '{C:blue}#1#{} hand each round'
        },
        ['unlock'] = {
            'Unlocked by default.'
        }
    },
    pos = { x = 4, y = 1 },
    cost = 10,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_plays } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key = 'c_fool',
                                edition = 'e_negative'
                            }
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = 'Afterimage!', colour = G.C.PURPLE },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
    end,    
}


-- Rare Joker 2/7
-- Prism
SMODS.Joker {
    key = "j_prism",
    config = {
        extra = {
            --final_hand_played = 0
        }
    },
    loc_txt = {
        ['name'] = 'Prism',
        ['text'] = {
            'Create a random {C:spectral}Spectral{} card',
            'after beating a {C:attention}Boss Blind{}',
            '{C:inactive}(Must have room){}'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 5, y = 1 },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

--[[
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.final_hand_played  } }
    end,
--]]

    calculate = function(self, card, context)
      if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and
          #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
              G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1        
              return {
                  extra = {
                      message = localize('k_plus_spectral'),
                      message_card = card,
                      func = function() -- This is for timing purposes, everything here runs after the message
                          G.E_MANAGER:add_event(Event({
                              func = (function()
                                  SMODS.add_card {
                                      set = 'Spectral',
                                  }
                                  G.GAME.consumeable_buffer = 0
                                  return true
                              end)
                          }))
                      end
                  },
              }
      end
    end
}

-- Rare Joker 3/7
-- The Call
SMODS.Joker {
    key = "j_thecall",
    config = {
        extra = {
            xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'The Call',
        ['text'] = {
            'Each {C:attention}Wild{} card',
            'held in hand',
            'gives {X:red,C:white}X#1#{} Mult'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 6, y = 1 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round
            and SMODS.get_enhancements(context.other_card)["m_wild"] == true then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else                
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

-- Rare Joker 4/7
-- Flashlight
SMODS.Joker {
    key = "j_flashlight",
    config = {
        extra = {
          xmult = 0.1,
          rank = 'Ace',
          id = 14,
          suit = 'Spades',
          xmult_mod = 1,
          initialize = false
        }
    },
    loc_txt = {
        ['name'] = 'Flashlight',
        ['text'] = {
            'Each played {C:attention}#2#{} of {V:1}#4#{}',
            'gains {X:red,C:white}X#1#{} Mult and',
            'scores accumulated {X:red,C:white}X Mult{}',
            '{s:0.8}Card changes every round{}',
            '{C:inactive}(Currently {X:red,C:white}X#5#{C:inactive} Mult){}'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 7, y = 1 },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',
    
    loc_vars = function(self, info_queue, card)
      local suitcolor = 0
      if not card.ability.extra.initialize then
        card.ability.extra.initialize = true
        -- Gather all of the existing ranks and suits from current deck
        local valid_cards = {}
        if G.playing_cards then
          for _, playing_card in ipairs(G.playing_cards) do
              if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                table.insert(valid_cards, playing_card)
              end
          end
          local fl_card = pseudorandom_element(valid_cards, 'peridot_flashlight')
          if fl_card then
              card.ability.extra.rank = fl_card.base.value
              card.ability.extra.suit = fl_card.base.suit
              card.ability.extra.id = fl_card.base.id
          end
        else
        end
      end
      if card.ability.extra.suit == 'Spades'       then suitcolor = G.C.SUITS.Spades
      elseif card.ability.extra.suit == 'Hearts'   then suitcolor = G.C.SUITS.Hearts
      elseif card.ability.extra.suit == 'Clubs'    then suitcolor = G.C.SUITS.Clubs
      elseif card.ability.extra.suit == 'Diamonds' then suitcolor = G.C.SUITS.Diamonds
      end   
      
      return { vars = { card.ability.extra.xmult, 
          card.ability.extra.rank, card.ability.extra.id, card.ability.extra.suit, card.ability.extra.xmult_mod, card.ability.extra.initialize,
          colours = { suitcolor } } }
    end,    

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:get_id() == card.ability.extra.id and
            context.other_card:is_suit(card.ability.extra.suit) then
              
              card.ability.extra.xmult_mod = card.ability.extra.xmult_mod + card.ability.extra.xmult
              return {
                            no_juice = true,
                            xmult = card.ability.extra.xmult_mod
              }
        end

        if context.end_of_round then
          local valid_cards = {}
          for _, playing_card in ipairs(G.playing_cards) do
              if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                table.insert(valid_cards, playing_card)
              end
          end
          local fl_card = pseudorandom_element(valid_cards, 'peridot_flashlight')
          if fl_card then
              card.ability.extra.rank = fl_card.base.value
              card.ability.extra.suit = fl_card.base.suit
              card.ability.extra.id = fl_card.base.id
          end
          if card.ability.extra.suit == 'Spades'       then suitcolor = G.C.SUITS.Spades
          elseif card.ability.extra.suit == 'Hearts'   then suitcolor = G.C.SUITS.Hearts
          elseif card.ability.extra.suit == 'Clubs'    then suitcolor = G.C.SUITS.Clubs
          elseif card.ability.extra.suit == 'Diamonds' then suitcolor = G.C.SUITS.Diamonds
          end             
        end
    end,
}

-- Rare Joker 5/7
-- Golden Eagle
SMODS.Joker {
    key = "j_goldeneagle",
    config = {
        extra = {
          xmult = 0.1,
          xmult_mod = 1
        }
    },
    loc_txt = {
        ['name'] = 'Golden Eagle',
        ['text'] = {
                   'This Joker gains {X:red,C:white}X#1#{} Mult',
                   'per played {C:gold}Gold{} card',
                   '{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)'
        },
        ['unlock'] = {
            ''
        }
    },
    pos = { x = 8, y = 1 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)       
      return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod } }
    end,       

    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.debuffed_hand then
            local golds = 0
            for _, playing_card in ipairs(context.scoring_hand) do
              if playing_card.config.center.key == "m_gold" and not playing_card.debuff then
                    golds = golds + 1
                end
            end
            if golds > 0 then
                card.ability.extra.xmult_mod = card.ability.extra.xmult_mod + card.ability.extra.xmult * golds
                return {
                  message  = 'X' .. card.ability.extra.xmult_mod .. ' Mult',
                  colour = G.C.GOLD,
                  message_card = card
                  }
            end
        end
        if context.joker_main and card.ability.extra.xmult_mod > 1 then
            return {
                xmult = card.ability.extra.xmult_mod
            }
        end
    end,
}

-- Rare Joker 6/7
-- Sea Lion
SMODS.Joker {
    key = "j_sealion",
    config = {
        extra = {
            xmult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Sea Lion',
        ['text'] = {
            'First played card',
            'with any {C:attention}seal{} gives',
            ' {X:red,C:white}X#1#{} Mult when scored',
        },
        ['unlock'] = {
            'Unlocked by default.'
        }
    },
    pos = { x = 9, y = 1 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
          return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local is_first = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].seal then
                    is_first = context.scoring_hand[i] == context.other_card
                    break
                end
            end
            if is_first then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
      
    end
}

-- Rare Joker 7/7
-- Chameleon
SMODS.Joker {
    key = "j_chameleon",
    config = {
        extra = {
            xmult = 0.1,
            xmult_mod = 1,
            suit = 'Spades',
            suit_number = 0,
            initialize = false
        }
    },
    loc_txt = {
        ['name'] = 'Chameleon',
        ['text'] = {
            'Adds {X:mult,C:white}X#1#{} Mult for every',
            '{C:attention}scorable card{} in your full deck',
            'with the {V:1}#3#{} suit ({V:1}#4#{})',
            '{s:0.8}Suit changes every hand{}',
            '{C:inactive}(Currently {}{X:mult,C:white}X#2#{}{C:inactive} Mult){}'
            
        },
        ['unlock'] = {
            'Unlocked by default.'
        }
    },
    pos = { x = 0, y = 2 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'PeridotJokers',

    loc_vars = function(self, info_queue, card)
      -- Randomly determine suit and supply color for text description
      local suitcolor = G.C.SUITS.Spades
      if card.ability.extra.initialize == 0 then
        
        local valid_suits = {}
        if G.playing_cards then
          for _, playing_card in ipairs(G.playing_cards) do
              if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                table.insert(valid_suits, playing_card.base.suit)
              end
          end
          local ch_suit = pseudorandom_element(valid_suits, 'peridot_chameleon')
          if ch_suit then
              card.ability.extra.suit = ch_suit
          else
              card.ability.extra.suit = 'Spades'
          end
        else
        end        
      end

      if     card.ability.extra.suit == 'Spades'   then suitcolor = G.C.SUITS.Spades
      elseif card.ability.extra.suit == 'Hearts'   then suitcolor = G.C.SUITS.Hearts
      elseif card.ability.extra.suit == 'Clubs'    then suitcolor = G.C.SUITS.Clubs
      elseif card.ability.extra.suit == 'Diamonds' then suitcolor = G.C.SUITS.Diamonds
      end          
      
      -- Initial value calculation for the joker description prior to purchase (i.e. viewing through collection, etc)
      if not card.ability.extra.initialize then
        card.ability.extra.xmult_mod = 13 * card.ability.extra.xmult + 1
        card.ability.extra.suit_number = 13       
        card.ability.extra.initialize = true
      else
        local suit_count = 0
        if G.playing_cards and card.ability.extra.initialize == 1 then
            for _, playing_card in pairs(G.playing_cards) do
                  if playing_card:is_suit(card.ability.extra.suit) then
                    suit_count =  suit_count + 1
                  end
            end
            card.ability.extra.xmult_mod = suit_count * card.ability.extra.xmult + 1
            card.ability.extra.suit_number = suit_count
        end
      end
        
      return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod, card.ability.extra.suit, 
          card.ability.extra.suit_number, card.ability.extra.initialize, colours = { suitcolor } } }
    end,
    
    calculate = function(self, card, context)
      if context.joker_main then
        return { xmult = card.ability.extra.xmult_mod }
      end
      
      if context.final_scoring_step and G.GAME.hands_played ~= card.ability.extra.hands_played then
        local suitcolor = G.C.SUITS.Spades
        local valid_suits = {}
        if G.playing_cards then
          for _, playing_card in ipairs(G.playing_cards) do
              if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                table.insert(valid_suits, playing_card.base.suit)
              end
          end
          local ch_suit = pseudorandom_element(valid_suits, 'peridot_chameleon')
          if ch_suit then
              card.ability.extra.suit = ch_suit
          else
              card.ability.extra.suit = 'Spades'
          end
        else
        end        
      end

        if     card.ability.extra.suit == 'Spades'   then suitcolor = G.C.SUITS.Spades
        elseif card.ability.extra.suit == 'Hearts'   then suitcolor = G.C.SUITS.Hearts
        elseif card.ability.extra.suit == 'Clubs'    then suitcolor = G.C.SUITS.Clubs
        elseif card.ability.extra.suit == 'Diamonds' then suitcolor = G.C.SUITS.Diamonds
        end          
        
        local suit_count = 0
        if G.playing_cards then
            for _, playing_card in pairs(G.playing_cards) do
                  if playing_card:is_suit(card.ability.extra.suit) then
                    suit_count =  suit_count + 1
                  end
            end
            card.ability.extra.xmult_mod = suit_count * card.ability.extra.xmult + 1
            card.ability.extra.suit_number = suit_count
        end        
    end
}
