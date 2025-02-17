namespace :friendly_id do
  # Regenerate slugs for all projects
  desc "Regenerate slugs for all projects"
  task regenerate_projet_slugs: :environment do
    puts "Regenerating slugs for #{Projet.count} projects..."

    Projet.find_each do |projet|
      puts "Processing projet: #{projet.titre}"
      begin
        projet.slug = nil
        projet.save!
        puts "Generated slug: #{projet.slug}"
      rescue => e
        puts "Error processing #{projet.titre}: #{e.message}"
      end
    end

    puts "Finished regenerating slugs!"
  end

  # Regenerate slugs for all articles
  desc "Regenerate slugs for all articles"
  task regenerate_article_slugs: :environment do
    puts "Regenerating slugs for #{Article.count} articles..."

    Article.find_each do |article|
      puts "Processing article: #{article.titre}"
      begin
        article.slug = nil
        article.save!
        puts "Generated slug: #{article.slug}"
      rescue => e
        puts "Error processing #{article.titre}: #{e.message}"
      end
    end

    puts "Finished regenerating slugs!"
  end
end
