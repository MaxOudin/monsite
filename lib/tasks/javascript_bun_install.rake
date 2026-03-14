# jsbundling-rails requiert un fichier lockfile (bun.lockb, yarn.lock, etc.) pour
# auto-détecter le gestionnaire de paquets. Ce projet utilise bin/install-bun
# pour télécharger bun à la volée, sans lockfile commité.
# Cette tâche remplace javascript:install pour installer bun puis les dépendances.

Rake::Task["javascript:install"].clear if Rake::Task.task_defined?("javascript:install")

task "javascript:install" do
  system("bash bin/install-bun && bun install") ||
    abort("Échec de l'installation des dépendances JavaScript via bun")
end
